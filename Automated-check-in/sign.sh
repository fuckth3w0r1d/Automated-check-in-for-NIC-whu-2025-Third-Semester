#!/bin/bash
echo "[+]正在更新远程分支......"
git fetch origin
echo "[+]更新完毕"
signDate=$(date +"%Y-%m-%d")
roomID="000" #替换你的教室号
ssID="0000000000000" #替换你的学号
signedBranchFind=0
echo "[+]正在检索已签到的分支......"
for branch in $(git branch -r | grep -v 'HEAD');do
        branch=$(echo "${branch}" | xargs)
        if git ls-tree -r --name-only "${branch}" 2>/dev/null | grep -q "${signDate}";then
                echo "[+]找到已签到的分支：${branch#origin/}"
                branch="${branch#origin/}"
		signedBranchFind=1
                break
        fi
done
if (( signedBranchFind == 0 ));then
	echo "[+]未发现已签到分支，请稍后再试"
	exit 0
fi
echo "[+]正在爆破签到码,请耐心等待......"
signHashKey=$(git show "origin/${branch}:${signDate}")
signPassword=$(python3 signPassword.py "${branch:0:13}" "${signHashKey}")
echo "[+]发现签到码：$signPassword"
echo "[+]正在签到......"
branch="${ssID}your_name" #替换你的姓名小写拼音
signKey=${ssID}${signPassword}${roomID}
signHashKey=$(echo -n "${signKey}" | md5sum) 
signHashKey="${signHashKey:0:-3}"
echo "[+]签到字符串为"
echo ${signKey}
echo "[+]计算哈希为"
echo ${signHashKey}
echo "[+]正在创建签到文件......"
echo -n ${signHashKey} > "${signDate}"
echo "[+]正在上传签到文件......"
git add "${signDate}"
git commit -m "Sign for "${signDate}""
git push origin ${branch}
echo "[+]签到完成"



