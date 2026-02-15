#!/bin/bash
#==============================================================================
# Vivado下载和安装自动化脚本
# 功能：自动化下载、安装、配置Vivado
//==============================================================================

set -e  # 遇到错误立即退出

#==============================================================================
# 配置参数
#==============================================================================

# 安装目录
INSTALL_DIR="/tools/Xilinx"
VIVADO_VERSION="2022.1"  # 可以根据实际下载的版本修改

# 许可证文件
LICENSE_FILE="/home/app/vivado_lic2037.lic"

# 下载目录
DOWNLOAD_DIR="/home/app/downloads/vivado"
mkdir -p "$DOWNLOAD_DIR"

# 日志
LOG_FILE="$DOWNLOAD_DIR/vivado_install.log"
exec > >(tee -a "$LOG_FILE")
exec 2>&1

#==============================================================================
# 打印带时间戳的日志
#==============================================================================
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

#==============================================================================
# 检查系统要求
#==============================================================================
log "检查系统要求..."

# 检查磁盘空间
AVAILABLE_SPACE=$(df -BG / | awk 'NR==2 {print $4}')
log "可用磁盘空间: ${AVAILABLE_SPACE}G"

if [ "$AVAILABLE_SPACE" -lt 40 ]; then
    log "错误：磁盘空间不足，需要至少40GB"
    exit 1
fi

# 检查内存
TOTAL_MEM=$(free -g | awk '/^Mem:/{print $2}')
log "系统内存: ${TOTAL_MEM}GB"

if [ "$TOTAL_MEM" -lt 4 ]; then
    log "警告：内存不足4GB，可能影响安装"
fi

# 检查架构
ARCH=$(uname -m)
log "系统架构: $ARCH"

if [ "$ARCH" != "x86_64" ]; then
    log "错误：Vivado只支持x86_64架构"
    exit 1
fi

log "系统检查通过 ✓"

#==============================================================================
# 检查并安装依赖
#==============================================================================
log "检查依赖包..."

# 安装必要依赖
sudo apt-get update

# 安装依赖
sudo apt-get install -y \
    build-essential \
    gcc \
    g++ \
    make \
    libncurses5-dev \
    libftdi1-dev \
    libssl-dev \
    zlib1g-dev \
    libxext-dev \
    libxrender-dev \
    libxtst-dev \
    libpng-dev \
    libgraphite2-dev \
    libcairo2-dev \
    libpango1.0-dev \
    libglib2.0-dev \
    libgtk-3-dev

log "依赖安装完成 ✓"

#==============================================================================
# 下载Vivado
#==============================================================================
log "准备下载Vivado..."

# Xilinx Vivado下载页面
VIVADO_URL="https://www.xilinx.com/member/forms/download/xef?filename=Xilinx_Unified_2022.1_0610_1234_Lin64.bin"

log "=========================================="
log "下载Vivado需要以下步骤："
log "=========================================="
log ""
log "1. 访问Xilinx下载中心："
echo "   https://www.xilinx.com/support/download.html"
log ""
log "2. 注册Xilinx账号（免费）"
log ""
log "3. 登录后搜索 'Vivado Linux' 或访问："
echo "   https://www.xilinx.com/support/download/duration/vivado.html"
log ""
log "4. 下载 'Linux Self Extracting Web Installer'"
log "   文件名类似：Xilinx_Unified_2022.1_0610_1234_Lin64.bin"
log "   大小：约5GB（Web安装器）"
log ""
log "5. 或者下载完整安装包（约30GB）："
log "   Xilinx_Vivado_ML_2022.1_0610_1234_Lin64.tar.gz"
log ""
log "=========================================="
log ""
log "下载选项："
log ""
log "A. 手动下载后，将文件放到：$DOWNLOAD_DIR"
log "   然后继续运行此脚本"
log ""
log "B. 使用wget/curl直接下载（需要Xilinx账号cookies）"
log ""
log "C. 使用Xilinx下载管理器"
log ""

# 询问用户
read -p "你是否已经下载了Vivado安装包？(y/n): " DOWNLOADED

if [ "$DOWNLOADED" = "y" ]; then
    log "请提供下载的文件路径："
    read -p "> " INSTALLER_FILE

    if [ ! -f "$INSTALLER_FILE" ]; then
        log "错误：文件不存在: $INSTALLER_FILE"
        exit 1
    fi

    log "找到安装包: $INSTALLER_FILE"
else
    log "请先下载Vivado安装包，然后重新运行此脚本"
    log ""
    log "下载完成后，运行："
    echo "  bash $0"
    exit 0
fi

#==============================================================================
# 安装Vivado
#==============================================================================
log "开始安装Vivado..."

# 创建安装目录
sudo mkdir -p "$INSTALL_DIR"
sudo chown $USER:$USER "$INSTALL_DIR"

# 提取版本信息
INSTALLER_NAME=$(basename "$INSTALLER_FILE")
log "安装包: $INSTALLER_NAME"

# 运行安装程序
log "启动Vivado安装程序..."
log "安装目录: $INSTALL_DIR"
log "许可证文件: $LICENSE_FILE"
log ""
log "=========================================="
log "安装提示："
log "=========================================="
log ""
log "在安装向导中："
log "1. 选择 'Vivado' 产品"
log "2. 选择版本: $VIVADO_VERSION"
log "3. 选择安装路径: $INSTALL_DIR"
log "4. 选择要安装的组件："
log "   - Vivado Design Suite"
log "   - 至少选择一个器件系列（如 Artix-7, Kintex-7）"
log "5. 许可证配置："
log "   - 选择 'Load License File'"
log "   - 文件: $LICENSE_FILE"
log ""
log "=========================================="
log ""

# 检查是否为图形界面安装
if [ -z "$DISPLAY" ]; then
    log "警告：未检测到图形界面，将使用命令行模式"

    # 命令行模式安装
    chmod +x "$INSTALLER_FILE"

    # 需要用户确认
    read -p "是否继续安装？(y/n): " CONFIRM
    if [ "$CONFIRM" != "y" ]; then
        log "安装已取消"
        exit 0
    fi

    # 运行安装程序
    "$INSTALLER_FILE" --mode batch \
        --accept_eula \
        --location "$INSTALL_DIR" \
        --edition "Vivado ML Standard" \
        --product "Vivado"
else
    # 图形界面模式
    log "启动图形安装程序..."
    chmod +x "$INSTALLER_FILE"
    "$INSTALLER_FILE"
fi

#==============================================================================
# 配置环境变量
#==============================================================================
log "配置环境变量..."

# 检测安装路径
VIVADO_PATH=$(find "$INSTALL_DIR" -name "settings64.sh" 2>/dev/null | head -1)

if [ -z "$VIVADO_PATH" ]; then
    log "错误：未找到Vivado安装"
    exit 1
fi

VIVADO_DIR=$(dirname "$VIVADO_PATH")
log "Vivado安装路径: $VIVADO_DIR"

# 添加到 ~/.bashrc
BASHRC="$HOME/.bashrc"

if ! grep -q "$VIVADO_DIR" "$BASHRC"; then
    log "添加环境变量到 $BASHRC"

    cat >> "$BASHRC" << EOF

# Xilinx Vivado
export XILINX_VIVADO=$VIVADO_DIR
export PATH=\$PATH:$VIVADO_DIR/bin
export XILINX_LICENSE_FILE=$LICENSE_FILE
EOF

    log "环境变量已添加 ✓"
else
    log "环境变量已存在"
fi

# 使当前会话生效
export XILINX_VIVADO="$VIVADO_DIR"
export PATH="$PATH:$VIVADO_DIR/bin"
export XILINX_LICENSE_FILE="$LICENSE_FILE"

#==============================================================================
# 验证安装
#==============================================================================
log "验证安装..."

if command -v vivado &> /dev/null; then
    VIVADO_VERSION=$(vivado -version | head -1)
    log "Vivado安装成功！"
    log "$VIVADO_VERSION"
else
    log "警告：vivado命令未在PATH中找到"
    log "请运行：source ~/.bashrc"
fi

#==============================================================================
# 测试许可证
#==============================================================================
log "检查许可证..."

if [ -f "$LICENSE_FILE" ]; then
    log "许可证文件存在: $LICENSE_FILE"

    # 显示许可证信息
    head -5 "$LICENSE_FILE"
else
    log "警告：许可证文件未找到: $LICENSE_FILE"
fi

#==============================================================================
# 创建快捷方式
#==============================================================================
log "创建快捷方式..."

BIN_DIR="$HOME/bin"
mkdir -p "$BIN_DIR"

cat > "$BIN_DIR/vivado" << 'EOF'
#!/bin/bash
source ~/.bashrc
vivado "$@"
EOF

chmod +x "$BIN_DIR/vivado"
log "快捷方式已创建: $BIN_DIR/vivado"

#==============================================================================
# 完成
#==============================================================================
log ""
log "=========================================="
log "Vivado安装完成！"
log "=========================================="
log ""
log "安装位置: $VIVADO_DIR"
log "许可证: $LICENSE_FILE"
log ""
log "下一步："
log "1. 运行以下命令使环境变量生效："
echo "   source ~/.bashrc"
log ""
log "2. 验证安装："
echo "   vivado -version"
log ""
log "3. 运行综合脚本："
echo "   cd ~/systolic_array_edge/script"
echo "   ./run_vivado.sh"
log ""
log "=========================================="

exit 0
