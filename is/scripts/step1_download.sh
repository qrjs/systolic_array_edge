#!/bin/bash
#==============================================================================
# Vivado下载检查和准备脚本
#==============================================================================

echo "=========================================="
echo "Vivado下载准备 - 步骤1"
echo "=========================================="
echo ""

#==========================================================================
# 检查下载环境
#==========================================================================
echo "1. 检查下载环境"
echo "-------------------------------"

# 检查磁盘空间
AVAILABLE=$(df -BG $HOME | awk 'NR==2 {print $4}')
echo "✓ 可用磁盘空间: ${AVAILABLE}GB"

if [ "$AVAILABLE" -lt 10 ]; then
    echo "⚠️  警告：磁盘空间不足10GB，建议清理空间"
    echo ""
fi

# 检查网络连通性
if ping -c 1 google.com &> /dev/null; then
    echo "✓ 网络连接正常"
else
    echo "⚠️  网络连接可能有问题"
fi

# 创建下载目录
DOWNLOAD_DIR="$HOME/downloads/vivado"
mkdir -p "$DOWNLOAD_DIR"
echo "✓ 下载目录: $DOWNLOAD_DIR"

echo ""

#==========================================================================
# 下载选项
#==========================================================================
echo "2. 下载选项"
echo "-------------------------------"
echo ""
echo "Vivado提供两种下载方式："
echo ""
echo "  [A] Web Installer（推荐）"
echo "      - 文件大小：约5GB"
echo "      - 安装时在线下载组件"
echo "      - 下载时间：5-15分钟"
echo ""
echo "  [B] Full Image（完整包）"
echo "      - 文件大小：约25-30GB"
echo "      - 包含所有组件"
echo "      - 下载时间：30-60分钟"
echo ""
echo "推荐选择：[A] Web Installer"
echo ""

#==========================================================================
# 下载链接信息
#==========================================================================
echo "3. 下载链接和步骤"
echo "-------------------------------"
echo ""
echo "方法A：使用浏览器下载（推荐）"
echo ""
echo "  步骤1：打开浏览器，访问："
echo "        https://www.xilinx.com/support/download.html"
echo ""
echo "  步骤2：注册/登录Xilinx账号"
echo "        - 如果没有账号，点击 'Register' 注册（免费）"
echo "        - 使用邮箱注册，需要邮箱验证"
echo ""
echo "  步骤3：搜索 'Vivado Linux' 或访问："
echo "        https://www.xilinx.com/support/download/duration/vivado.html"
echo ""
echo "  步骤4：选择版本"
echo "        推荐版本：Vivado 2022.1 或更新版本"
echo "        选择：Linux Self Extracting Web Installer"
echo ""
echo "  步骤5：开始下载"
echo "        文件名类似：Xilinx_Unified_2022.1_0610_1234_Lin64.bin"
echo "        保存到：$DOWNLOAD_DIR"
echo ""
echo "=========================================="
echo ""

#==========================================================================
# 等待用户下载
#==========================================================================
echo "当前状态：等待下载完成"
echo ""
echo "下载完成后，运行以下命令继续："
echo ""
echo "  cd ~/systolic_array_edge/script"
echo "  ./install_vivado.sh"
echo ""
echo "或者，如果下载到了其他位置："
echo ""
echo "  mv ~/Downloads/Xilinx_Unified*.bin $DOWNLOAD_DIR/"
echo "  cd ~/systolic_array_edge/script"
echo "  ./install_vivado.sh"
echo ""
echo "=========================================="
echo ""

# 提供监控下载的选项
echo "提示：如果想监控下载进度："
echo ""
echo "  # 方法1：查看下载目录大小"
echo "  watch -n 5 'du -sh $DOWNLOAD_DIR'"
echo ""
echo "  # 方法2：查看是否有.bin文件"
echo "  ls -lh $DOWNLOAD_DIR/*.bin 2>/dev/null || echo '等待下载...'"
echo ""
echo "=========================================="

# 询问用户是否已开始下载
read -p "你是否已经打开了浏览器并准备下载？(y/n): " STARTED

if [ "$STARTED" = "y" ]; then
    echo ""
    echo "太好了！请按照上面的步骤在浏览器中下载。"
    echo ""
    echo "下载完成后，回到这里运行："
    echo "  cd ~/systolic_array_edge/script"
    echo "  ./install_vivado.sh"
    echo ""
else
    echo ""
    echo "需要我提供更详细的指导吗？"
    echo ""
    echo "1. 我没有Xilinx账号"
    echo "2. 我找不到下载链接"
    echo "3. 其他问题"
    echo ""
    read -p "请输入问题编号(1/2/3)或按Enter跳过: " QUESTION

    case "$QUESTION" in
        1)
            echo ""
            echo "=========================================="
            echo "如何注册Xilinx账号"
            echo "=========================================="
            echo ""
            echo "1. 访问：https://www.xilinx.com/registration/create-account.html"
            echo ""
            echo "2. 填写信息："
            echo "   - Email：你的邮箱"
            echo "   - Password：设置密码"
            echo "   - First Name/Last Name：你的姓名"
            echo "   - Company：学校名称（学生）或公司"
            echo "   - Job Title：Student（如果是学生）"
            echo "   - Country：China"
            echo ""
            echo "3. 点击 'Create Account'"
            echo ""
            echo "4. 检查邮箱，点击验证链接"
            echo ""
            echo "5. 返回下载页面，登录账号"
            echo ""
            ;;
        2)
            echo ""
            echo "=========================================="
            echo "直接下载链接"
            echo "=========================================="
            echo ""
            echo "方法1：使用直接搜索"
            echo "  Google搜索：'Xilinx Vivado download 2022.1'"
            echo ""
            echo "方法2：直接访问下载页面"
            echo "  https://www.xilinx.com/member/forms/download/xef?filename=Xilinx_Unified_2022.1_0610_1234_Lin64.bin"
            echo ""
            echo "注意：直接链接需要先登录Xilinx账号"
            echo ""
            ;;
        3)
            echo ""
            echo "请描述你的问题："
            read PROBLEM
            echo ""
            echo "问题记录：$PROBLEM"
            echo "请尝试以下解决方案："
            echo "1. 检查网络连接"
            echo "2. 更换浏览器（Chrome/Firefox）"
            echo "3. 清除浏览器缓存"
            echo "4. 使用不同的网络"
            echo ""
            ;;
    esac
fi

echo ""
echo "=========================================="
echo "准备完成！"
echo "=========================================="
echo ""
echo "下载提示："
echo "- 确保网络稳定"
echo "- 下载约5GB，需要5-30分钟"
echo "- 下载保存到：$DOWNLOAD_DIR"
echo "- 下载完成后，文件扩展名为 .bin"
echo ""
echo "=========================================="
