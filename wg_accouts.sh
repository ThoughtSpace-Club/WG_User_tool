#!/usr/bin/env bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

#=================================================
#	System Required: CentOS 6+/Debian 6+/Ubuntu 14.04+
#	Description: Install the wireguard mudbjson server
#	Version: 1.0.26
#	Author: felix
#	Blog: https://doub.io/ss-jc60/
#=================================================

wg_ver=""
filepath = $(cd "$(dirname "$0")"; pwd)
file=$(echo -e "${filepath}"|awk -F "$0" '{print $1}')
wg_folder="/usr/local/brook"
config_file="${wg_folder}/config.json"
config_user_file="${wg_folder}/user-config.json"
config_user_api_file="${wg_folder}/userapiconfig.py"
config_user_mudb_file="${wg_folder}/mudb.json"
wg_log_file="${wg_folder}/wg_server.log"
Libsodiumr_file="/usr/local/lib/libsodium.so"  //  
Libsodiumr_ver_backup="1.0.15"  //
Server_Speeder_file="/serverspeeder/bin/serverSpeeder.sh"  //
LotServer_file="/appex/bin/serverSpeeder.sh"   //
BBR_file="${file}/bbr.sh"//
jq_file="${wg_folder}/jq"

Green_font_prefix="\033[32m" && Red_font_prefix="\033[31m" && Green_background_prefix="\033[42;37m" && Red_background_prefix="\033[41;37m" && Font_color_suffix="\033[0m"
Info="${Green_font_prefix}[信息]${Font_color_suffix}"
Error="${Red_font_prefix}[错误]${Font_color_suffix}"
Tip="${Green_font_prefix}[注意]${Font_color_suffix}"
Separator_1="——————————————————————————————"

function check_root(){
	[[ $EUID != 0 ]] && echo -e "${Error} 当前账号非ROOT(或没有ROOT权限)，无法继续操作，请使用${Green_background_prefix} sudo su ${Font_color_suffix}来获取临时ROOT权限（执行后会提示输入当前账号的密码）。" && exit 1
}
function check_sys(){
	if [[ -f /etc/redhat-release ]]; then
		release="centos"
	elif cat /etc/issue | grep -q -E -i "debian"; then
		release="debian"
	elif cat /etc/issue | grep -q -E -i "ubuntu"; then
		release="ubuntu"
	elif cat /etc/issue | grep -q -E -i "centos|red hat|redhat"; then
		release="centos"
	elif cat /proc/version | grep -q -E -i "debian"; then
		release="debian"
	elif cat /proc/version | grep -q -E -i "ubuntu"; then
		release="ubuntu"
	elif cat /proc/version | grep -q -E -i "centos|red hat|redhat"; then
		release="centos"
    fi
	bit=`uname -m`
}
function check_pid(){
	PID=`ps -ef |grep -v grep | grep server.py |awk '{print $2}'`
}
function check_crontab(){
	[[ ! -e "/usr/bin/crontab" ]] && echo -e "${Error} 缺少依赖 Crontab ，请尝试手动安装 CentOS: yum install crond -y , Debian/Ubuntu: apt-get install cron -y !" && exit 1
}


function start_menu(){
    check_sys

    if [[ "${action}" == "clearall" ]]; then
	Clear_transfer_all
elif [[ "${action}" == "monitor" ]]; then
	crontab_monitor_ssr
else
	echo -e "  WireGuard MuJSON一键管理脚本 ${Red_font_prefix}[v${sh_ver}]${Font_color_suffix}
  ---- Toyo | doub.io/ss-jc60 ----

  ${Green_font_prefix}1.${Font_color_suffix} 安装 WireGuard
  ${Green_font_prefix}2.${Font_color_suffix} 更新 WireGuard
  ${Green_font_prefix}3.${Font_color_suffix} 卸载 WireGuard
  ${Green_font_prefix}4.${Font_color_suffix} 安装 libsodium(chacha20)
————————————
  ${Green_font_prefix}5.${Font_color_suffix} 查看 账号信息
  ${Green_font_prefix}6.${Font_color_suffix} 显示 连接信息
  ${Green_font_prefix}7.${Font_color_suffix} 设置 用户配置
  ${Green_font_prefix}8.${Font_color_suffix} 手动 修改配置
  ${Green_font_prefix}9.${Font_color_suffix} 配置 流量清零
————————————
 ${Green_font_prefix}10.${Font_color_suffix} 启动 WireGuard
 ${Green_font_prefix}11.${Font_color_suffix} 停止 WireGuard
 ${Green_font_prefix}12.${Font_color_suffix} 重启 WireGuard
 ${Green_font_prefix}13.${Font_color_suffix} 查看 WireGuard 日志
————————————
 ${Green_font_prefix}14.${Font_color_suffix} 其他功能
 ${Green_font_prefix}15.${Font_color_suffix} 升级脚本
 "
	menu_status
	echo && read -e -p "请输入数字 [1-15]：" num
    case "$num" in
    
}