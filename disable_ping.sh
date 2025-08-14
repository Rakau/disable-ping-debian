#!/bin/bash

# 检查脚本是否以root权限运行
if [ "$EUID" -ne 0 ]; then
  echo "请使用root用户或sudo运行此脚本"
  exit 1
fi

# 立即禁用 ping（ICMP Echo 响应）
sysctl -w net.ipv4.icmp_echo_ignore_all=1

# 配置文件路径
CONF_FILE="/etc/sysctl.d/99-disable-ping.conf"

# 如果已有旧的 disable-ping 配置文件，先备份
if [ -f "$CONF_FILE" ]; then
  cp "$CONF_FILE" "${CONF_FILE}.bak.$(date +%F-%T)"
fi

# 写入永久配置
echo "net.ipv4.icmp_echo_ignore_all=1" > "$CONF_FILE"

# 重新加载 sysctl 配置
sysctl --system

echo "已禁用 ICMP Echo（ping）响应，重启后依然生效。"
