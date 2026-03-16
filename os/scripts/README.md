# OS 脚本说明

当前推荐直接使用 `Makefile`，不再依赖旧的 shell 回归脚本。

## 子目录入口
```bash
make -C scripts sim SIM=iverilog
make -C scripts sim SIM=vcs
make -C scripts wave SIM=iverilog
make -C scripts wave SIM=vcs
make -C scripts view SIM=iverilog VIEWER=surfer
make -C scripts view SIM=vcs VIEWER=verdi
make -C scripts txt SIM=iverilog
make -C scripts txt SIM=vcs
make -C scripts synth
make -C scripts clean
```

## 根目录快捷入口
```bash
make os
make os-vcs
make os-wave
make os-surfer
make os-verdi-vcs
make os-txt
make os-synth
```
