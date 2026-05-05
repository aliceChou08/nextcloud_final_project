#!/bin/bash

# 只要任何指令失敗，就立即結束腳本
set -e

# 1. 互動式詢問密碼
read -sp "輸入 Ansible Vault 密碼: " VAULT_PASSWORD
echo -e "\n密碼已接收，建立暫時憑證檔...\n"

# 建立一個暫時的密碼檔，讓 Ansible 自動讀取，不用一直輸入
#將密碼存在一個隨機生成的安全位置
#這個變數代表一個隨機暫存路徑
PASSWORD_FILE=$(mktemp)
#密碼存入那個路徑
echo "$VAULT_PASSWORD" > "$PASSWORD_FILE"

# 確保腳本結束就刪除密碼檔，保護安全性
trap "rm -f $PASSWORD_FILE" EXIT

EXTRA_VARS="ansible/vars/nextcloud_vars.yml"
START_TIME=$(date +%s)

# 定義一個執行函數，減少重複程式碼
run_playbook() {
    #步驟幾
    local step_name=$1
    #哪一個ansible
    local playbook=$2
    echo "------------------------------------------"
    echo "執行步驟 $step_name: $playbook"
    
    ansible-playbook ansible/"$playbook" \
        -e "@$EXTRA_VARS" \
        --vault-password-file "$PASSWORD_FILE"
    #將變數檔用密碼解密 
}

run_playbook "1" "update.yml"
run_playbook "2" "docker_env.yml"
run_playbook "3" "install_postgresql.yml"
run_playbook "4" "install_nextcloud.yml"

echo "等待 Nextcloud 容器完全啟動..."
sleep 20


run_playbook "6" "ldaps_cert.yml"
run_playbook "7" "nc_ldaps.yml"
run_playbook "8" "mnt_smbfile_up.yml"
run_playbook "9" "mnt_smbfile_down.yml"
run_playbook "10" "cloudflaretunnel.yml"

# 結束計時
END_TIME=$(date +%s)
TOTAL_SECONDS=$((END_TIME - START_TIME))
MINUTES=$((TOTAL_SECONDS / 60))
SECONDS=$((TOTAL_SECONDS % 60))

echo "=========================================="
echo " 執行完畢"
echo "總耗時: ${MINUTES} 分 ${SECONDS} 秒"
echo "完成時間: $(date '+%Y-%m-%d %H:%M:%S')"
echo "=========================================="
                                                   
