# mini-npu

用 PyCDE（CIRCT 的 Python 绑定）以高抽象层次编写 NPU 数据通路模块，然后逐模块与
Arm Ethos-U55 官方 RTL（`rtl_ref/`，来自 Dragon-Git/ethosu55）做**等价性验证**，
验证工具为 Yosys EQY，全部在 GitHub Actions 上完成（本地不需要装 pycde / circt /
yosys）。

## 验证目标（9 个模块）

| PyCDE 模块 (`npu/`)            | ARM 参考实现 (`rtl_ref/`)          | 说明 |
|--------------------------------|-----------------------------------|------|
| `bin2onehot`                   | `ethosu55_bin2onehot`             | one-hot 译码器 |
| `onehot_mux` (N=4, W=8)        | `ethosu55_onehot_mux`             | one-hot 选择 mux |
| `rr_arb` (WIDTH=6)             | `ethosu55_rr_arb`                 | 轮询仲裁器 |
| `rr_reg_arb` (WIDTH=6)         | `ethosu55_rr_reg_arb`             | 带计数器的轮询仲裁器 |
| `or_tree_w6`                   | `ethosu55_or_tree_w6`             | 6 输入 OR 树 |
| `back_buf` (D=3, W=64)         | `ethosu55_back_buf`               | 带 bypass 的深度缓冲 |
| `reg_fifo` (W=32, D=16)        | `ethosu55_reg_fifo`               | 寄存器堆 FIFO |
| `multi_pipe_stage` (W=64, R=2) | `ethosu55_multi_pipe_stage`       | valid/ready 流水级 |
| `stream_len`                   | `ethosu55_dma_stream_len`         | DMA burst 长度计算 |

## 关键设计决策

- **gold/gate 方向**：gold = ARM RTL（yosys 3 值 x-prop 语义，合法化 case default
  `'x'` 臂），gate = PyCDE 生成代码。详见 `docs/eqy-notes.md`。
- **复位语义**：ARM RTL 全部是异步低有效复位；PyCDE 高层 `Reg()` 只支持同步复位，
  所以 `npu/reg_util.py` 用 `seq.FirRegOp(..., isAsync=True)` 精确复刻。
- **顶层命名**：gold 顶层统一改名 `<m>_gold`（`script/make_gold_renames.py`），
  与 gate 顶层 `<m>` 在 .eqy 里显式 `match/collect/partition` 配对；端口名逐一对应。
- **unpacked 端口适配**：`ethosu55_dma_stream_len` 的 `axi_config_t` 是 unpacked
  数组端口，gate 侧用 packed [87:0]，gold 侧由 `stream_len_gold_wrapper` 打平。
- **存储结构**：`reg_fifo`/`back_buf` 的存储在 ARM RTL 里就是带译码使能的寄存器堆，
  gate 侧同样用逐槽寄存器 + 译码 mux 表达，避免引入 memory 建模问题。

## CI

`equiv` workflow（`.github/workflows/equiv.yml`）：

1. **gen** job：pip 装 `pycde==0.11.0`（x86_64 manylinux wheel），跑
   `script/gen_sv.py` 生成 SV + `script/make_gold_renames.py` 生成 gold 侧文件。
2. **equiv** job × 9（每个模块一个）：下载 oss-cad-suite（yosys + eqy + sby），
   跑 `eqy -f eqy/<m>.eqy`，出现 `PASS` 文件才算成功；日志全部作为 artifact 上传。

## 本地复现（可选，需要 x86_64）

```bash
pip install pycde==0.11.0
python3 script/gen_sv.py build
python3 script/make_gold_renames.py
export PATH=/path/to/oss-cad-suite/bin:$PATH
for f in eqy/*.eqy; do eqy -f "$f" && cat PASS; done
```
