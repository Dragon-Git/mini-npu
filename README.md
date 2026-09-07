# mini-npu

用 PyCDE（CIRCT 的 Python 前端）以高抽象层次 Python 代码编写 NPU 数据通路模块，
生成 SystemVerilog，然后**逐模块**与 Arm Ethos-U55 官方 RTL（`rtl_ref/`）做
**等价性验证**（Yosys EQY），全部证明通过。验证跑在 GitHub Actions 上
（本地无 oss-cad-suite / 无 pycde，也能靠 CI 完成闭环）。

```
PyCDE (Python)  ──CIRCT──▶  SystemVerilog (gold)
                                   │
Arm Ethos-U55 RTL (gate) ──────────┤
                                   ▼
                        Yosys EQY (sat / sby)  ──▶ PASS per module
```

## 模块对照表

| mini-npu (PyCDE, gold)  | rtl_ref (ARM, gate)              | 说明 |
|-------------------------|----------------------------------|------|
| `bin2onehot`            | `ethosu55_bin2onehot`            | one-hot 译码器（128） |
| `onehot_mux`            | `ethosu55_onehot_mux`            | one-hot 选择 mux（N=4, W=8 实例化） |
| `rr_arb`                | `ethosu55_rr_arb`                | 组合 round-robin 仲裁器 |
| `rr_reg_arb`            | `ethosu55_rr_reg_arb`            | 带 rr 计数器的仲裁器（含时序） |
| `or_tree_w6`            | `ethosu55_or_tree_w6`            | 6 输入 OR 树（CDC 单元树） |
| `back_buf`              | `ethosu55_back_buf`              | bypass/skid 缓冲（DEPTH=3, W=64） |
| `reg_fifo`              | `ethosu55_reg_fifo`              | 寄存器 FIFO（32x16，EN_COLLISION=0） |
| `multi_pipe_stage`      | `ethosu55_multi_pipe_stage`      | valid/ready 流水级（多 reader valid 复制） |
| `stream_len`            | `ethosu55_dma_stream_len`        | DMA AXI burst 长度计算（组合，含 get_max_beats 函数） |

## 关键设计点

- **异步复位**：ARM RTL 全部是 `always_ff @(posedge clk or negedge reset_n)`
  异步低有效复位。PyCDE 高层 `Reg()` 只能生成同步复位（seq.compreg），
  所以所有寄存器走 `npu/reg_util.py::async_reg()`（`seq.firreg` +
  `isAsync=True`），保证 gold/gate 复位行为逐位一致 — 等价性验证的硬前提。
- **端口一一对应**：gold 模块端口名与 ARM 模块完全一致（含 `asrt_clk` /
  `asrt_rst_n` 这类纯断言端口）。ARM 侧统一改名 `<module>_gold`
  （`script/make_gold_renames.py`），PyCDE 侧保持原名，.eqy 里显式
  `match/collect/partition <m>_gold <m>` 配对。
- **gold/gate 方向**：gold = ARM RTL（3 值 x-prop 语义，合法化 case
  default `'x'` 臂），gate = PyCDE 生成代码（纯 2 值逻辑）。详见
  `docs/eqy-notes.md`。
- **unpacked 端口适配**：`ethosu55_dma_stream_len` 的 `axi_config_t` 是
  unpacked 数组端口，gate 侧用 packed [87:0]，gold 侧加
  `stream_len_gold_wrapper` 打平后再喂给原模块。
- **X 语义**：ARM case 的 `'x'` 默认臂靠 EQY 的 x-prop（gold 3 值语义）
  处理：gold=x 时 gate 任意值均匹配；可达输入空间内两者逐位一致。

## 目录结构

```
npu/            PyCDE 模型（gold 源码）
rtl_ref/        Arm Ethos-U55 RTL 子集（gate 参考实现，含 pkg）
eqy/            每个 gold/gate 对一个 .eqy 配置
script/         gen_sv.py（生成 SV）、make_gate_renames.py（gate 改名）
test/           本地单元测试（生成 + 烟雾检查）
.github/workflows/equiv.yml   CI：生成 + 9 个 EQY 等价性验证 job
```

## 本地运行（可选）

本地需要 pycde（x86_64 manylinux wheel）+ oss-cad-suite：

```bash
pip install pycde==0.11.0
python3 script/gen_sv.py build
python3 script/make_gold_renames.py
python3 script/make_gold_wrapper_stream_len.py
export PATH=/path/to/oss-cad-suite/bin:$PATH
for f in eqy/*.eqy; do eqy -f "$f" && cat PASS; done
```

不用本地装任何东西也行 — push 之后 CI 自动跑完 9 个等价性证明。

## 状态

CI 绿 = 全部 9 个模块等价性证明通过。
