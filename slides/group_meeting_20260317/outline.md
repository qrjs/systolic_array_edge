# 面向边缘计算的 4x4 脉动阵列阶段汇报

本目录用于生成明天组会使用的简短 PPT，范围刻意排除了功能覆盖率部分。

## Slide 1

- 标题：面向边缘计算的 4x4 脉动阵列阶段汇报
- 副标题：WS / IS / OS 对比与改进型 DiP 进展
- 说明：本次汇报暂不展开功能覆盖率

## Slide 2

- 研究主线：统一 4x4 平台上比较 WS / IS / OS
- 核心对象：改进型 DiP
- 统一口径：接口、位宽、向量、脚本、ASIC handoff

## Slide 3

- 当前工程进展
- 四套标准顶层、统一回归、中文文档、商业流程目录整理
- 强调后端实跑待另一台服务器

## Slide 4

- 改进型 DiP 的三项 RTL 优化
- `stage1_mac_en`
- invalid 周期保持
- 输出寄存稳定

## Slide 5

- 当前结果快照
- `make regress`: `1072/1072 PASS`
- `make dip-txt`: `268/268 PASS`
- `avg_skip_pct = 52.41%`
- `LUT/FF/DSP = 1286 / 1920 / 16`
- `Total/Dynamic Power = 0.100 / 0.030 W`
- `Setup Slack = +1.546 ns`

## Slide 6

- 下一步与组会讨论
- 后端服务器、工艺库、流程优先级
- 论文第 4/5 章初稿推进
