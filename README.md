# nextcloud_final_project
nextcloud final project 自動化部署

## 功能特色
外網人員能藉由nextcloud存取公司內網的File server

## 環境需求
1. 需要一台控制主機-參考[控制主機文件](control_host.txt)
2. 兩台rockey linux,需設置好ip
3. 一台DC跟一台File server,都是windows server,且加入AD網域
4. AD網域內需要一台企業CA
5. DC需要跟CA申請一張憑證
6. 將憑證複製到控制主機
7. 修改[vars檔](ansible/vars/nextcloud_vars.yml)使得符合建置環境
8. 用公司往遇到cloudflare幫nextcloud申請一個tunnel,連到port80
   - name server改成cloudflare
   - (詳細可參考技術文件[技術文件](技術文件.docx))

## 目錄圖
```text

.
├── ansible
│   ├── cloudflaretunnel.yml
│   ├── docker_env.yml
│   ├── install_nextcloud.yml
│   ├── install_postgresql.yml
│   ├── ldaps_cert.yml
│   ├── mnt_smbfile_down.yml
│   ├── mnt_smbfile_up.yml
│   ├── nc_ldaps.yml
│   ├── update.yml
│   └── vars
│       └── nextcloud_vars.yml
├── auto_nextcloud.sh
├── control_host.md
├── images
│   └── 架構圖.jpg
├── README.md
├── SESE109_10_周劭郁_期末 .pptx
└── 技術文件.docx

```

## 專案架構圖
[架構圖](images/架構圖.jpg)


## 安裝與使用
- 特別注意一定要去更改[vars檔](ansible/vars/nextcloud_vars.yml)
1. clone
``` bash
git clone https://github.com/aliceChou08/nextcloud_final_project.git
```
2. 進到專案目錄
```bash
cd nextcloud_final_project
```
3. 執行
```bash
ansible-vault encrypt ansible/vars/nextcloud_vars.yml
bash auto_nextcloud.sh
```
在瀏覽器輸入cloudflare tunnel申請的網址

## 安裝時可能出現的問題
[錯誤圖](安裝錯誤圖.PNG)
- 重新下一次指令
```bash
bash auto_nextcloud.sh
```
- 可能原因: Nextcloud尚未安裝完畢

## 流程
1. [update system tools](ansible/update.yml)
2. [install docker](ansible/docker_env.yml)
3. [install postgreSQL](ansible/install_postgresql.yml)
4. [install Nextcloud](ansible/install_nextcloud.yml)
5. [update update-ca-trust extract of dc ](ansible/ldaps_cert.yml)
6. [ldpas' configuration](ansible/nc_ldaps.yml)
7. [mount external storages from file server](ansible/mnt_smbfile_up.yml)
8. [add filter for user to view files](ansible/mnt_smbfile_down.yml)
9. [add cloudflare tunnel for url](ansible/cloudflaretunnel.yml)

