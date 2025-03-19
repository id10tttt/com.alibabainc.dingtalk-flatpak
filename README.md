# com.alibabainc.dingtalk-flatpak
钉钉 flatpak

参考[微信打包](https://github.com/web1n/wechat-universal-flatpak)
#  自行编译
```
flatpak-builder --user --install --force-clean build-dir com.alibabainc.DingTalk.yaml
```

# 打开
```
flatpak run com.alibabainc.DingTalk
```

# libc6-amd64
```
    依赖glibc，该包随时可能更新，如果无法build报错，可以去 https://mirrors.ustc.edu.cn/debian/pool/main/g/glibc/ 下载对应的 libc6-amd64 包
    需要更改文件下载的URL和sha256sum
```