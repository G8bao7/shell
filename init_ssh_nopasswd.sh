#!/bin/sh

# 初始化 client使用的公钥文件 .ssh/authorized_keys
mkdir -p .ssh
cat /root/.ssh/id_dsa.pub > .ssh/authorized_keys

# auth.txt 每行格式: IP password
file=auth.txt
while read line
do
    arr=(`echo "$line" | awk '{print $1,$2}'`)
    tip=${arr[0]}
    tpwd=${arr[1]}
    echo "$tip "
    #continue
    expect -c "
        spawn scp -r .ssh root@$tip:/root/
        expect {
            \"(yes/no)\" {send \"yes\n\"; exp_continue;}
            \"assword:\" {send \"$tpwd\n\"; exp_continue;}
            \"100%\" {send_user \"100%\n\";}
        }
        expect eof"
done < $file
