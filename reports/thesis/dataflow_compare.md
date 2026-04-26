# Dataflow Compare

主表用于统一工程平台下的 WS/OS/IS/DiP 对比；DiP 的 clock gating 作为工程优化点单独标注。

| Arch | Flavor | DC Area | DC Dyn mW | Innovus Area | Innovus Total mW | Slack ns | Gate Sim | FM Innovus | DRC | Conn | Clock Gates |
| --- | --- | ---: | ---: | ---: | ---: | ---: | --- | --- | --- | --- | ---: |
| WS | plain | 21392.447753 | 0.668412 | 21254.52 | 3.691488 | 5.845 | 268/268 PASS | PASS | PASS | PASS | 0 |
| OS | plain | 20334.047722 | 1.172700 | 20107.92 | 7.471194 | 2.196 | 268/268 PASS | PASS | PASS | PASS | 0 |
| IS | plain | 21419.663744 | 1.357000 | 21263.928 | 7.363685 | 2.141 | 268/268 PASS | PASS | PASS | PASS | 0 |
| DIP | gated | 17367.671666 | 0.962882 | 17480.736 | 4.117761 | 2.038 | 268/268 PASS | PASS | PASS | PASS | 15 |
