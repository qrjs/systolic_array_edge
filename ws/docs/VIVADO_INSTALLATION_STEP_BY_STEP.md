# Vivado下载和安装 - 完整步骤指南

## 📋 第一步：下载Vivado（需要2-30分钟）

### 方法1：使用Xilinx官网下载（推荐）

#### 1.1 访问Xilinx下载中心
```
https://www.xilinx.com/support/download.html
```

#### 1.2 注册/登录Xilinx账号
- 如果没有账号，点击"Register"注册（免费）
- 使用邮箱注册后，会收到验证邮件
- 验证后登录

#### 1.3 找到Vivado下载页面
方法A：直接搜索
- 在搜索框输入"Vivado Linux"
- 或访问：https://www.xilinx.com/support/download/duration/vivado.html

方法B：导航菜单
- Products and Services → Design Tools → Vivado
- 选择"Vivado ML"或"Vivado HLx"系列

#### 1.4 选择版本
- 推荐版本：**Vivado 2022.1** 或更新版本
- 选择 "Linux Self Extracting Web Installer"
  - 大小：约5GB（安装时会在线下载其他组件）
  - 或选择 "Full Image"（完整安装包，约30GB）

#### 1.5 下载
- 点击下载后会生成一个下载凭证
- 下载的文件名类似：
  - `Xilinx_Unified_2022.1_0610_1234_Lin64.bin`（Web安装器）
  - 或 `Xilinx_Vivado_ML_2022.1_0610_1234_Lin64.tar.gz`（完整包）

### 方法2：使用wget下载（需要Cookies）

```bash
# 创建下载目录
mkdir -p ~/downloads/vivado
cd ~/downloads/vivado

# 使用wget下载（替换URL和版本号）
wget --content-disposition \
  --header="Cookie: XILINX_LICENSE_ACCEPTED=1" \
  "https://www.xilinx.com/member/forms/download/xef?filename=Xilinx_Unified_2022.1_0610_1234_Lin64.bin"
```

---

## 📥 第二步：准备安装文件

```bash
# 1. 移动下载的文件到统一目录
# 假设你下载到了 ~/Downloads
mv ~/Downloads/Xilinx_Unified*.bin ~/downloads/vivado/

# 2. 添加执行权限
chmod +x ~/downloads/vivado/Xilinx_Unified*.bin

# 3. 检查文件
ls -lh ~/downloads/vivado/
```

---

## ⚙️ 第三步：运行安装（30-60分钟）

### 方法1：使用自动化脚本（推荐）

```bash
cd ~/systolic_array_edge/script
./install_vivado.sh
```

脚本会自动：
- ✅ 检查系统要求
- ✅ 安装依赖包
- ✅ 运行安装程序
- ✅ 配置环境变量
- ✅ 验证安装

### 方法2：手动安装

#### 3.1 创建安装目录
```bash
sudo mkdir -p /tools/Xilinx
sudo chown $USER:$USER /tools/Xilinx
```

#### 3.2 运行安装程序
```bash
cd ~/downloads/vivado
./Xilinx_Unified_2022.1_0610_1234_Lin64.bin
```

#### 3.3 安装向导中的选择
1. **Welcome**：点击 Next
2. **Select Product to Install**：选择 "Vivado"
3. **Select Edition**：
   - 推荐选择 "Vivado ML Standard" 或 "Vivado HL System Edition"
   - 或如果有许可证，选择对应版本
4. **Accept License Agreements**：勾选 "I accept"
5. **Select Installation Destination**：
   - 输入：`/tools/Xilinx/Vivado/2022.1`
6. **Select Components to Install**：
   - 必选：Vivado Design Suite
   - 器件系列：至少选择一个（推荐 Artix-7 或 Kintex-7）
7. **Select Installation Summary**：确认后点击 Install
8. **等待安装**（30-60分钟）

---

## 🔧 第四步：配置环境

```bash
# 编辑 ~/.bashrc
nano ~/.bashrc

# 在文件末尾添加以下内容：

# Xilinx Vivado 2022.1
export XILINX_VIVADO=/tools/Xilinx/Vivado/2022.1
export PATH=$PATH:$XILINX_VIVADO/bin
export XILINX_LICENSE_FILE=/home/app/vivado_lic2037.lic

# 保存并退出（Ctrl+X, Y, Enter）

# 使配置生效
source ~/.bashrc
```

---

## ✅ 第五步：验证安装

```bash
# 1. 检查vivado命令
vivado -version

# 应显示类似：
# Vivado v2022.1 (64-bit)
# ...

# 2. 检查许可证
lmutil lmstat -a -c /home/app/vivado_lic2037.lic

# 3. 测试运行
vivado -mode tcl

# 在Vivado TCL控制台中输入：
# version
# exit
```

---

## 🎯 第六步：综合你的设计

```bash
cd ~/systolic_array_edge/script
./run_vivado.sh
```

这会：
1. 综合你的Verilog代码
2. 生成资源使用报告
3. 生成时序分析报告
4. 生成功耗分析报告

---

## 📊 查看综合报告

```bash
cd ~/systolic_array_edge/reports

# 资源使用报告
cat utilization_report.txt

# 时序报告
cat timing_report.txt

# 功耗报告
cat power_report.txt

# 完整的综合报告
cat vivado_synthesis_report.txt
```

---

## ⚠️ 常见问题

### 问题1：权限不足
```bash
sudo chown -R $USER:$USER /tools/Xilinx
```

### 问题2：许可证错误
```bash
# 检查许可证文件
ls -la /home/app/vivado_lic2037.lic

# 设置正确的环境变量
export XILINX_LICENSE_FILE=/home/app/vivado_lic2037.lic
```

### 问题3：找不到vivado命令
```bash
# 重新加载bash配置
source ~/.bashrc

# 或使用完整路径
/tools/Xilinx/Vivado/2022.1/bin/vivado -version
```

### 问题4：安装空间不足
```bash
# 检查可用空间
df -h / /home

# 如果空间不足，可以选择：
# 1. 清理系统文件
# 2. 安装到其他分区
# 3. 使用Web安装器（更小）
```

---

## 📞 需要帮助？

如果在安装过程中遇到问题：

1. **查看安装日志**
   ```bash
   cat ~/downloads/vivado/vivado_install.log
   ```

2. **检查系统兼容性**
   - 操作系统：Linux 64-bit
   - 内核版本：3.10或更高
   - glibc版本：2.14或更高

3. **Xilinx支持论坛**
   https://forums.xilinx.com/

---

## 💡 安装后立即使用

安装完成后，立即运行综合：

```bash
cd ~/systolic_array_edge/script
./run_vivado.sh
```

这将生成真实的资源使用报告！

---

**预计总时间**：
- 下载：2-30分钟（取决于网速）
- 安装：30-60分钟
- 配置：5分钟
- 综合：5-10分钟

**总计**：约1-2小时

---

准备好了吗？开始下载吧！🚀
