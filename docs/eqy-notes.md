# EQY 方法论与决策记录

## 为什么 gate=PyCDE, gold=ARM RTL（注意：本仓库方向）

EQY 的 x-prop 语义（`docs/source/xprop.rst`）：gold 端用 3 值（0/1/x）仿真
语义，gold 输出为 x 时该 check 自动通过（gate 可以是任意值）。ARM RTL 里
case 的 `default: 'x'` 臂、以及 `ALLOW_REQ_X` 类型的 X 容忍逻辑，都依赖
SV X 传播 — 把 ARM RTL 放在 gold 位置才能让这些 X 合法化；PyCDE 生成的是
确定性 2 值逻辑，放 gate 位置永远正确应答。

因此本仓库：**gold = ARM RTL（改名 `<m>_gold`），gate = PyCDE 生成代码**。

## 复位风格

ARM: `always_ff @(posedge clk or negedge reset_n)` — 异步、低有效、复位到 0。
PyCDE 高层 `Reg()` → `seq.compreg`（同步复位），不匹配。
解法：`npu/reg_util.py::async_reg()` 直接建 `seq.firreg`（`isAsync=True`），
lowering 后生成等价的异步复位 always 块（CIRCT `FirRegLowering` 对 async
reset 生成 `always_ff @(posedge clk or negedge rst)` + 初始自赋值结构）。

## EQY 配对机制（读 eqy.py 源码确认）

- `[match]` 缺省时 `gold-match *`：gold 实体按名字在 gate 里找同名实体。
- gold/gate 顶层模块名不同（`<m>_gold` vs `<m>`），所以显式
  `match <m>_gold <m>` + `collect <m>_gold <m>` + `partition <m>_gold <m>`。
- 模式替换支持 `\1` 反向引用（shell 通配 `*` 编译成捕获组）。

## X 处理

- ARM case default `'x'` 臂（如 `get_max_beats` 的 default）依赖 gold 的
  3 值语义合法化（见上）。
- PyCDE 端不生成任何 x（2 值确定逻辑）。

## stream_len 的 axi_config_t

`axi_config_t = axi_config_elem_t[3:0]`（unpacked）。eqy read 时
`-Smem2reg` 会把 unpacked 端口变 memory；为绕开，gate 端加 wrapper
`stream_len_gold_wrapper`：把原模块的 unpacked 端口打平成 packed [87:0]
再连出来。gold 端口本来就是 packed [87:0]
（`axi_config_elem_t = 22bit`：max_beats[1:0] + memtype[3:0] +
max_outst_rd[7:0] + max_outst_wr[7:0]，struct 首成员在 MSB 端，
即 elem 内 [21:20] 是 max_beats）。

注意：`region_t` 是 `logic [1:0]`（索引 0..3），所以 axi_cfg 共 4 个元素
×22bit = 88bit，不是 2 个。

## 一个坑：eqy read_verilog 包依赖

ARM pkg 互相 import（ethosu55_pkg → cc_reg_pkg → tsu_pkg → dma_pkg），
yosys read_verilog 只在单文件内解析 import；所以 .eqy 的 [gold] 把 pkg
按依赖顺序全部 read 进去，再 read 模块文件。
