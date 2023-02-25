#!/bin/bash

# 色の設定
GREEN='\033[0;32m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
RED='\033[1;31m' # 太字
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

# CSVファイル名
csv_file="translations.csv"

# 言語の選択
echo
echo "Select a language 言語を選択してください :"
echo
echo "1. English"
echo "2. 日本語"
echo
read -t30 -p "Enter the number 数字を入力してください : " lang_choice

# 選択された言語に応じた列番号を設定
case $lang_choice in
1)
    lang_col=2 # 英語列
    ;;
2)
    lang_col=3 # 日本語列
    ;;
*)
    echo "無効な選択です。"
    exit 1
    ;;
esac

# CSVファイルからメッセージを読み込み
while read line; do
    # キー名を取得
    # cutコマンドでカンマを区切り文字とし、1列目のフィールドを抽出
    key=$(echo $line | cut -d ',' -f 1)
    # 選択された言語に対応するメッセージを取得
    # awk -Fオプションを使ってフィールド区切り文字を`,`に指定、$で$lang_colで指定された列を取得
    # この方法であれば、フィールドの値の中に,が含まれていても正しく取得することが可能
    message=$(echo $line | awk -F ',' '{print $'$lang_col'}')
    # 変数に格納
    eval "$key=\"$message\""
done <$csv_file

echo
echo
echo
echo
echo
echo -e "${NC}-----------------------------------------------------------------------------------------------------${NC}"
# リモートサーバーのIPアドレスを取得する
ip_address=$(ip addr show | grep -oP '(?<=inet\s)\d+(\.\d+){3}' | grep -v '127.0.0.1' | head -n1)
# echo -e "$PLUGIN_NODE_IP : $ip_address"
printf "%-20s : %s\n" "$PLUGIN_NODE_IP" "$ip_address"

# リモートユーザーとして現在のユーザーを取得する
remote_user=$(whoami)
# echo -e "$PLUGIN_NODE_USER : $remote_user"
printf "%-20s : %s\n" "$PLUGIN_NODE_USER" "$remote_user"

# リモートバックアップディレクトリを設定する
backup_dir="/plinode_backups/"
# echo -e "$PLUGIN_NODE_BACKUP_DIR : $backup_dir"
printf "%-20s : %s\n" "$PLUGIN_NODE_BACKUP_DIR" "$backup_dir"

# バックアップファイルを保存するローカルディレクトリを設定する
local_dir="~/Documents/plugin_node/$HOSTNAME"_"$ip_address$backup_dir"
# echo -e "$PLUGIN_NODE_LOCAL_DIR : $local_dir"
printf "%-20s : %s\n" "$PLUGIN_NODE_LOCAL_DIR" "$local_dir"

# sshd_configファイルからsshポート番号を取得する
ssh_port=$(sudo ss -tlpn | grep sshd | awk '{print$4}' | cut -d ':' -f 2 -s)

if [[ -z "$ssh_port" ]]; then
    ssh_port=22
fi

# echo -e "$PLUGIN_NODE_SSH_PORT : $ssh_port"
printf "%-20s : %s\n" "$PLUGIN_NODE_SSH_PORT" "$ssh_port"

# SSHキーが存在するかを確認する
sshkey_exists=0

if grep -q "ssh-dss" ~/.ssh/authorized_keys 2>/dev/null; then
    sshkey_type="dsa"
    sshkey_exists=1
elif grep -q "ssh-rsa" ~/.ssh/authorized_keys 2>/dev/null; then
    sshkey_type="rsa"
    sshkey_exists=1
elif grep -q "ecdsa-sha2-nistp" ~/.ssh/authorized_keys 2>/dev/null; then
    sshkey_type="ecdsa"
    sshkey_exists=1
elif grep -q "ssh-ed25519" ~/.ssh/authorized_keys 2>/dev/null; then
    sshkey_type="ed25519"
    sshkey_exists=1
elif grep -q "rsa-sha2-256" ~/.ssh/authorized_keys 2>/dev/null; then
    sshkey_type="rsa-pss"
    sshkey_exists=1
elif grep -q "ssh-x25519" ~/.ssh/authorized_keys 2>/dev/null; then
    sshkey_type="x25519"
    sshkey_exists=1
elif grep -q "ssh-x448" ~/.ssh/authorized_keys 2>/dev/null; then
    sshkey_type="x448"
    sshkey_exists=1
fi

if [ $sshkey_exists -eq 1 ]; then
    # SSHキーを使用してrsyncを実行する
    echo -e "$SSH_KEY_DETECTED : $sshkey_type"
    echo -e "${NC}-----------------------------------------------------------------------------------------------------${NC}"
    echo
    echo
    echo
    echo
    echo
    echo -e "${YELLOW}                              $REMOTE_SERVER   =====>>   $LOCAL_MACHINE                             ${NC}"
    echo -e "${YELLOW}-----------------------------------------------------------------------------------------------------${NC}"
    echo
    private_key="~/.ssh/id_${sshkey_type}"
    # Create the local directory if it does not exist
    echo -e "${YELLOW}mkdir -p $local_dir && rsync -avz --progress -e 'ssh -i ${NC}${RED}${private_key}${NC}${YELLOW} -p ${ssh_port}' ${remote_user}@${ip_address}:$backup_dir ${local_dir}${NC}"
    echo
    echo -e "${YELLOW}-----------------------------------------------------------------------------------------------------${NC}"
    echo -e "${YELLOW}$DOWNLOAD_BACKUP${NC}"
    echo
    echo
    echo
    echo
    echo
    echo -e "                              $REMOTE_SERVER   <<=====   $LOCAL_MACHINE                             "
    echo -e "${NC}-----------------------------------------------------------------------------------------------------${NC}"
    echo
    echo -e "${NC}rsync -avz --progress -e 'ssh -i '${RED}${private_key}${NC} -p ${ssh_port}' ${local_dir} ${remote_user}@${ip_address}:$backup_dir${NC}"
    echo
    echo -e "${NC}-----------------------------------------------------------------------------------------------------${NC}"
    echo -e "${NC}$UPLOAD_BACKUP${NC}"
    echo -e "${NC}$NOTE: $REPLACE${NC} ${RED}${private_key}${NC}${NC} $PRIVATE_KEY_PATH_FILENAME${NC}"
    echo
    echo
    echo
    echo
    echo
else
    # ※ SSHキーを使用せずにrsyncを実行する
    echo -e "${YELLOW}$SSH_KEY_NOT_DETECTED${NC}"
    echo -e "${NC}-----------------------------------------------------------------------------------------------------${NC}"
    echo
    echo
    echo
    echo
    echo
    echo -e "${YELLOW}                              $REMOTE_SERVER   =====>>   $LOCAL_MACHINE                             ${NC}"
    echo -e "${YELLOW}-----------------------------------------------------------------------------------------------------${NC}"
    echo
    echo -e "${YELLOW}mkdir -p $local_dir && rsync -avz --progress -e 'ssh -p ${ssh_port}' ${remote_user}@${ip_address}:$backup_dir ${local_dir}${NC}"
    echo
    echo -e "${YELLOW}-----------------------------------------------------------------------------------------------------${NC}"
    echo -e "${YELLOW}$DOWNLOAD_BACKUP${NC}"
    echo
    echo
    echo
    echo
    echo
    echo -e "                              $REMOTE_SERVER   <<=====    $REMOTE_SERVER                             "
    echo -e "${NC}-----------------------------------------------------------------------------------------------------${NC}"
    echo
    echo -e "${NC}rsync -avz --progress -e 'ssh -p ${ssh_port}' ${local_dir} ${remote_user}@${ip_address}:$backup_dir${NC}"
    echo
    echo -e "${NC}-----------------------------------------------------------------------------------------------------${NC}"
    echo -e "${NC}$UPLOAD_BACKUP${NC}"
    echo
    echo
    echo
    echo
    echo
fi

# echo "メッセージテスト"
# echo "$GET_IP_ADDRESS"
# echo "$GET_REMOTE_USER"
# echo "$SET_REMOTE_BACKUP_DIR"
# echo "$SET_LOCAL_BACKUP_DIR"
# echo "$GET_SSH_PORT"
# echo "$CHECK_SSH_KEYS"
# echo "$RSYNC_SSH_KEYS"
# echo "$RSYNC_WITHOUT_SSH_KEYS"
# echo "$SSH_KEY_DETECTED"
# echo "$DOWNLOAD_BACKUP"
# echo "$REMOTE_SERVER"
# echo "$LOCAL_MACHINE"
# echo "$UPLOAD_BACKUP"
# echo "$SSH_KEY_NOT_DETECTED"
# echo "$REPLACE"
# echo "$PRIVATE_KEY_PATH_FILENAME"
# echo "$PLUGIN_NODE_IP"
# echo "$PLUGIN_NODE_USER"
# echo "$PLUGIN_NODE_BACKUP_DIR"
# echo "$PLUGIN_NODE_LOCAL_DIR"
# echo "$PLUGIN_NODE_SSH_PORT"
# echo "$PLUGIN_NODE_SSHKEY_TYPE"
# echo "$NOTE"
