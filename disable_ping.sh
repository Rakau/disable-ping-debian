#!/bin/bash

# 检查脚本是否以root权限运行
if [ "$EUID" -ne 0 ]; then
  echo "请使用root用户或sudo运行此脚本"
  exit 1
fi

# 设置内核参数，立即生效
sysctl -w net.ipv4.icmp_echo_ignore_all=1

# 备份sysctl.conf
cp /etc/sysctl.conf /etc/sysctl.conf.bak.$(date +%F-%T)

# 判断是否已经存在该设置，存在则替换，否则追加
if grep -q "^net.ipv4.icmp_echo_ignore_all" /etc/sysctl.conf; then
  sed -i "s/^net.ipv4.icmp_echo_ignore_all=.*/net.ipv4.icmp_echo_ignore_all=1/" /etc/sysctl.conf
else
  echo "net.ipv4.icmp_echo_ignore_all=1" >> /etc/sysctl.conf
fi

# 重新加载sysctl配置（可选，确保文件配置生效）
sysctl -p

echo "已禁用ICMP Echo回应（ping），重启后依然生效。"
