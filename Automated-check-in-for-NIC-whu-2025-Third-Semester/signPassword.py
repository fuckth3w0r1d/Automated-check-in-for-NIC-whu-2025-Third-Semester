import sys
import hashlib
def get_md5_hash(signKey):
    md5_hash=hashlib.md5()
    md5_hash.update(signKey.encode('utf-8'))
    return md5_hash.hexdigest()
ssID=sys.argv[1]
signHashKey=sys.argv[2]
roomID="000" #替换成你的教室号
for i in range(1000000):
    i=f"{i:06d}"
    signKey=ssID+i+roomID
    signHashKey_try=get_md5_hash(signKey)
    if signHashKey_try == signHashKey:
        print(i)
        break


