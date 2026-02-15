# 🚀 Vivado下载 - 正确的下载位置

## ⚠️ 重要：下载位置

**正确的下载目录**：`/home/app/downloads/vivado`

```bash
# 创建下载目录
mkdir -p /home/app/downloads/vivado
```

---

## 📋 完整下载步骤

### 第1步：打开浏览器访问Xilinx

复制这个链接到浏览器：
```
https://www.xilinx.com/support/download.html
```

### 第2步：登录/注册Xilinx账号

**如果需要注册**：
1. 点击 "Register"
2. 填写：
   - Email：你的邮箱
   - Company：你的学校（如：XX大学）
   - Job Title：**Student**（学生免费）
   - Country：China
3. 验证邮箱后登录

### 第3步：找到Vivado下载

页面中找到 **"Vivado Design Suite"** 部分

或直接访问：
```
https://www.xilinx.com/support/download/duration/vivado.html
```

### 第4步：选择并下载

1. **版本**：选择 Vivado 2022.1 或更新版本
2. **平台**：选择 **Linux**
3. **类型**：选择 **Linux Self Extracting Web Installer**
   - 大小：约5GB
   - 文件名：`Xilinx_Unified_2022.1_0610_1234_Lin64.bin`

### 第5步：保存到正确位置 ⚠️

浏览器下载时，保存到：
```
/home/app/downloads/vivado/
```

或者在浏览器下载设置中设置默认下载目录为 `/home/app/downloads`

---

## ✅ 下载完成后

```bash
# 1. 检查下载的文件
ls -lh /home/app/downloads/vivado/*.bin

# 应该看到一个 4-6GB 的 .bin 文件

# 2. 运行安装脚本
cd ~/systolic_array_edge/script
./install_vivado.sh
```

---

## 📝 如果已经下载到了其他位置

如果你已经下载到了 `~/Downloads` 或其他位置：

```bash
# 移动到正确位置
mv ~/Downloads/Xilinx_Unified*.bin /home/app/downloads/vivado/

# 然后运行安装脚本
cd ~/systolic_array_edge/script
./install_vivado.sh
```

---

## 💡 重要提示

- ⚠️ **下载位置**：`/home/app/downloads/vivado`
- ⚠️ **文件大小**：约5GB
- ⚠️ **文件类型**：`.bin` 文件
- ✅ **预计时间**：5-30分钟（取决于网速）

---

## 🎯 现在开始

1. 复制链接到浏览器：https://www.xilinx.com/support/download.html
2. 登录/注册Xilinx账号
3. 下载 Vivado Linux Web Installer
4. **保存到 `/home/app/downloads/vivado/`**
5. 下载完成后告诉我！

准备好了吗？🚀
