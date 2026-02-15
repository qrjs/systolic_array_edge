# OS (Output Stationary) 架构

## 架构说明
Output Stationary数据流：输出驻留在PE中，输入从上方流入，权重从左侧流入。

## 目录结构
- `src/` - 设计代码
- `tb/` - 测试代码
- `scripts/` - 测试脚本
- `tools/` - Python工具
- `docs/` - 文档
- `tests/` - 测试向量

## 快速开始
```bash
# 运行测试
bash scripts/run_os_test.sh

# 或运行所有测试
bash scripts/run_all_tests.sh
```

## 测试覆盖
- 100个测试用例
- Python Golden Model验证
- 100%期望值覆盖

## 详细信息
参见 `docs/ARCHITECTURE.md`
