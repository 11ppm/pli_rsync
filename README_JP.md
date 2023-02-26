<br/>
<p align="center">
<img src="https://github.com/11ppm/pm2_log/blob/main/img/img2.jpg" width="225" alt="PluginJapan">
</a>
</p>
<br/>

# pli_rsync

[README English](https://github.com/11ppm/pli_rsync/blob/main/README.md)

## 概要
* rsyncを使って、プラグインノードのバックアップファイルを、VPSからローカルマシンに転送できるコマンドを作成します
* 同時に、ローカルマシンからプラグインノードへバックアップファイルを転送できるコマンドも作成します
* 各種暗号に対応。以下は、スクリプトで検出される可能性のあるSSH鍵のタイプのリストです
     * ssh-dss
     * ssh-rsa
     * ecdsa-sha2-nistp
     * ssh-ed25519
     * rsa-sha2-256
     * ssh-x25519
     * ssh-x448

  したがって、このスクリプトでは、DSA、RSA、ECDSA、Ed25519、RSA-PSS、x25519、x448の鍵タイプを検知します

* 日本語と英語に対応
     * `tranlations.csv`を作成し、日本語と英語に対応させました
     * 必要であれば、他の言語にも対応しますので、お知らせください

## 機能
1. CSVファイルから英語と日本語のメッセージを読み込み、選択された言語に応じてメッセージを表示します
2. プラグインノードのバックアップファイルを、ローカルに転送します
3. またローカルからプラグインノードへ、バックアップファイルを転送することもできます
4. rsyncはssh-keyにも対応しています

## rsyncについて
rsyncは、ファイル同期ツールです。主に、2つの異なる場所のファイル/ディレクトリを同期させるために使用されます。rsyncは、ローカルマシンとリモートマシン間でファイルを同期させることができ、ネットワーク経由でファイルを転送することができます。

rsyncの主な機能は、変更された部分だけを転送することができることです。つまり、同期元と同期先のファイルの差分を計算し、差分がある部分のみを転送することで、大量のデータを転送する場合に非常に効率的に動作します。

おそらくプラグインノードには、インストールされていると思われます。`rsync --version`で確認ができます。もしインストールされていない馬合は以下のコマンドを実行して、インストールしてください。
```
sudo apt install rsync
```

## スクリプトの実行

リポジトリを`git clone`し、`pli_rsync`ディレクトリに入り、`pli_rsync.sh`の実行権限を変更します。
```
git clone https://github.com/11ppm/pli_rsync
cd pli_rsync
chmod +x pli_rsync.sh
```

実行します
```
./pli_rsync.sh
```

英語か日本語を選択します。パスワードを求められますので、入力します。
```
Select a language 言語を選択してください :

1. English
2. 日本語

Enter the number 数字を入力してください : 1

[sudo] password for Doraemon: 

                                       Your Plugin Node                                          
-----------------------------------------------------------------------------------------------------
IP Address           : 194.233.80.250
User                 : Doraemon
Backup Directory     : /plinode_backups/
Local Directory      : ~/Documents/plugin_node/CT-TEST_194.233.80.250/plinode_backups/
SSH Port             : 22
※ SSH key was not detected 
-----------------------------------------------------------------------------------------------------


                             Plugin Node    =====>>    Local Machine                             
-----------------------------------------------------------------------------------------------------

mkdir -p ~/Documents/plugin_node/CT-TEST_194.233.80.250/plinode_backups/ && rsync -avz --progress -e 'ssh -p 22' Doraemon@194.233.80.250:/plinode_backups/ ~/Documents/plugin_node/CT-TEST_194.233.80.250/plinode_backups/

-----------------------------------------------------------------------------------------------------
To download backup file from the Plugin Node.run the following command in your local machine's terminal



                             Plugin Node    <<=====    Plugin Node                             
-----------------------------------------------------------------------------------------------------

rsync -avz --progress -e 'ssh -p 22' ~/Documents/plugin_node/CT-TEST_194.233.80.250/plinode_backups/ Doraemon@194.233.80.250:/plinode_backups/

-----------------------------------------------------------------------------------------------------
To upload backup files from your local machine to the Plugin Node.run the following command in your terminal on the local machine.
Note: Replace ~/.ssh/id_rsa with the appropriate path and filename of your private key.
```

## ローカルマシン（Linux,Macの場合）

Terminalを開いて、貼り付けて実行してください。


## ローカルマシン（Windowsの場合）

1. Cygwinをダウンロード
     https://www.cygwin.com/
     <img src="https://camo.qiitausercontent.com/2962471f20c4ad0667bf219a76c05c15bec0f52c/68747470733a2f2f71696974612d696d6167652d73746f72652e73332e61702d6e6f727468656173742d312e616d617a6f6e6177732e636f6d2f302f323531383930372f31313130303835302d333265612d616333372d616230372d3935393266653663383831322e706e67">


2. Cygwinをインストール
     <img src="https://camo.qiitausercontent.com/f15cda6571e12c8b07588ca9257711889ea3c5a8/68747470733a2f2f71696974612d696d6167652d73746f72652e73332e61702d6e6f727468656173742d312e616d617a6f6e6177732e636f6d2f302f323531383930372f31356235323566382d623536312d613332622d363037352d6232616633623038653335392e706e67)">
     
     

3. インストールパッケージの選択
   1. Category → Net → Openssh
   2. Category → Net → rsync

     <img src="https://camo.qiitausercontent.com/dff970b3ba8f32444ed216178adde73e30f9bcb6/68747470733a2f2f71696974612d696d6167652d73746f72652e73332e61702d6e6f727468656173742d312e616d617a6f6e6177732e636f6d2f302f323531383930372f65623532316464312d613665332d363338342d346633332d3338323033636135383762632e706e67">

     <img src="https://camo.qiitausercontent.com/147c8fd8f07921ac42c006baf89efc6e6d34ea95/68747470733a2f2f71696974612d696d6167652d73746f72652e73332e61702d6e6f727468656173742d312e616d617a6f6e6177732e636f6d2f302f323531383930372f36623337336531332d376130362d363430382d353663642d3661313736663862663763632e706e67">

     <img src="https://camo.qiitausercontent.com/d27a118dbd12da09adc3fce47b29c6ffeb6eb0ff/68747470733a2f2f71696974612d696d6167652d73746f72652e73332e61702d6e6f727468656173742d312e616d617a6f6e6177732e636f6d2f302f323531383930372f38626162666538612d383139662d333065322d306464372d3131323264313938323463372e706e67">

   
4. Cygwinを起動
     <img src="https://camo.qiitausercontent.com/d27a118dbd12da09adc3fce47b29c6ffeb6eb0ff/68747470733a2f2f71696974612d696d6167652d73746f72652e73332e61702d6e6f727468656173742d312e616d617a6f6e6177732e636f6d2f302f323531383930372f38626162666538612d383139662d333065322d306464372d3131323264313938323463372e706e67">

 

5. 隠しファイルを可視化し、`.ssh`が見えるようにする

     <img src="https://camo.qiitausercontent.com/8627846f9d29f7e86395763d432a172246cd2533/68747470733a2f2f71696974612d696d6167652d73746f72652e73332e61702d6e6f727468656173742d312e616d617a6f6e6177732e636f6d2f302f323531383930372f33363464343235642d343634622d323933652d353832342d6237633637396633303664392e706e67">

     <img src="https://camo.qiitausercontent.com/1ff47580fd81c4562a6f84f50329957d3dab0bce/68747470733a2f2f71696974612d696d6167652d73746f72652e73332e61702d6e6f727468656173742d312e616d617a6f6e6177732e636f6d2f302f323531383930372f36633362396538352d643837312d653835622d313339312d3536613963316332663366652e706e67">

     <img src="https://camo.qiitausercontent.com/eb4f5029e089c7fda0265aed7a33cb5c8a9edd0a/68747470733a2f2f71696974612d696d6167652d73746f72652e73332e61702d6e6f727468656173742d312e616d617a6f6e6177732e636f6d2f302f323531383930372f64316335306232642d373661312d663034382d373862372d6437613463613564326566632e706e67">

6. rsyncの実行

     <img src="https://camo.qiitausercontent.com/0fdb277361ff04fefddd27b1f3ff5e31bc802334/68747470733a2f2f71696974612d696d6167652d73746f72652e73332e61702d6e6f727468656173742d312e616d617a6f6e6177732e636f6d2f302f323531383930372f30613063376362652d333064652d316232352d633830332d3065343861333939653666662e706e67">

     <img src="https://camo.qiitausercontent.com/e2fd0fcaca2b311c74ca68f48d81505c256b8ce8/68747470733a2f2f71696974612d696d6167652d73746f72652e73332e61702d6e6f727468656173742d312e616d617a6f6e6177732e636f6d2f302f323531383930372f62343339373637382d323035622d643961362d653462332d3936383932386131316462662e706e67">

   <!-- <img src=""> -->