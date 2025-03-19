#!/bin/sh
export QT_QPA_PLATFORM=xcb
export QT_PLUGIN_PATH=/app/extra/dingtalk/current_version
cd /app/extra/dingtalk/current_version
preload_libs="./libgbm.so "

# check os_info
os_name=`cat /etc/os-release | grep ^ID= | cut -d'=' -f 2`
echo ${os_name}

# check architecture
os_machine=`uname -m`

libc_version=`ldd --version | grep ldd | cut -d' ' -f5`
libc_version_num=`echo "${libc_version}" | tr '.' ' '`
libc_version_m=0
libc_version_b=0
libc_lower=false
libc_lower_29=false # for cef109

for ia in ${libc_version_num}; do
  if [ ${libc_version_m} -eq 0 ]; then
   libc_version_m=$ia
  elif [ ${libc_version_b} -eq 0 ]; then
   libc_version_b=$ia
  fi
done

if [ ${libc_version_m} -lt 2 ]; then
    libc_lower=true
    libc_lower_29=true
fi
if [ ${libc_version_b} -lt 28 ]; then
    libc_lower=true
fi
if [ ${libc_version_b} -lt 29 ]; then
    libc_lower_29=true
fi
if [ ${libc_version_m} -gt 2 ]; then
    libc_lower=false
    libc_lower_29=false
fi

if [ "${os_name}" = "kylin" ]; then
    echo kylin branch
    if [ "${libc_lower}" = "true" ]; then 
        echo kylin v10 branch       
        preload_libs="./envlib.so ./libharfbuzz.so.0.20301.0 ./libgbm.so ./libidn2.so.0 ./libunistring.so.2 ./libz.so.1 "
    fi
    if [ "$os_machine" = "loongarch64" ] || [ "$os_machine" = "mips64" ]; then
        echo loongarch64 branch
        preload_libs="${preload_libs} ./libffi.so.6.0.4 "
    fi
    os_ver=`cat /etc/os-release | grep juniper`
    if [ ! -z "${os_ver}" ]; then
        echo ${os_ver}
        preload_libs="${preload_libs} ./libstdc++.so.6 "
    fi
else
    echo ${os_name} branch
    if [ "${libc_lower}" = "true" ]; then
        echo ${os_name} glibc lower branch 
        preload_libs="./envlib.so "
    fi
fi

is_enable_cef109=true
if [ "${is_enable_cef109}" = "true" ]; then
    if [ "$os_machine" = "aarch64" ]; then
        if [ "${libc_lower_29}" = "true" ]; then
            preload_libs="${preload_libs} ./libm-2.31.so "
        fi
    fi
    preload_libs="${preload_libs} ./plugins/dtwebview/libcef.so "
else
if [ "$os_machine" = "mips64" ]; then
    echo mips64el branch
    preload_libs="${preload_libs} ./plugins/dtwebview/libcef.so "
fi
fi

# preload_libs="${preload_libs} /app/lib/glibc/lib64/libm.so.6 /app/lib/libstdc/libstdc++.so.6 "
preload_libs="/app/lib/glibc/lib64/libm.so.6 /app/lib/libstdc/libstdc++.so.6 "
# preload_libs 
echo preload_libs=${preload_libs}
if [ ! -z "${preload_libs}" ]; then
    LD_PRELOAD="${preload_libs}" ./com.alibabainc.dingtalk $1
else
    ./com.alibabainc.dingtalk $1
fi