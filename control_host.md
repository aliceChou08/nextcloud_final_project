# 設定控制機器(ansible)
1.	更新linux
```bash
dnf -y update
```
2. 安裝epel
```bash
dnf -y install epel-release
```
3. 用python3-pip安裝ansible
- (rocky linux10只能裝ansible-core,所以用python裝)
```bash
dnf install -y python3-pip
#更新為最新版
python3 -m pip install --upgrade pip
python3 -m pip install ansible
```	
4. python 會將ansible的執行檔裝在目錄: /usr/local/bin底下,
所以要讓系統去那個目錄找(其他系統指令會放在$PATH)
```bash
vi .bashrc
  export PATH=/usr/local/bin:$PATH
```
 
- 立即生效
```bash
source ./.bashrc
```

5. 建立預設hosts和ansible.cfg檔 : ansible.sh
```bash
# 建資料夾 /etc/ansible
sudo mkdir -p /etc/ansible 

# 建立 inventory (預設主機檔存入hosts檔案內)
sudo tee /etc/ansible/hosts <<'EOF'
[linux]
[windows]
EOF

# 建立 config
sudo tee /etc/ansible/ansible.cfg <<'EOF'
[defaults]
inventory = /etc/ansible/hosts
host_key_checking = False
deprecation_warnings = False
interpreter_python = auto_legacy_silent
EOF
```
- 設定主機檔位置,不要特別警告以利自動化
-----------------------------------------------------------------------------------------------
-	sh  ansible.sh(執行)
-	建立機器庫存清單inventory
-	vi /etc/ansible/hosts
```bash
[linux]
192.168.0.1
192.168.0.2
[nextcloud_server]
192.168.0.1
[postgresql_server]
192.168.0.2
```

-	建立金鑰對
-	ssh-keygen
-	ssh-copy-id root@192.168.0.1 #公鑰匯入nextcloud那台主機,未來用它用來驗證控制主機
- ssh-copy-id root@192.168.0.2 #公鑰匯入postgresql那台主機,未來用它用來驗證控制主機
 
 
