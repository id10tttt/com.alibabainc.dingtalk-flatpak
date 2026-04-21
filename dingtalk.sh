#!/bin/bash

setup_ime_env() {
  if [[ "$XMODIFIERS" =~ fcitx ]]; then
    [ -z "$QT_IM_MODULE" ] && export QT_IM_MODULE=fcitx
    [ -z "$GTK_IM_MODULE" ] && export GTK_IM_MODULE=fcitx
  elif [[ "$XMODIFIERS" =~ ibus ]]; then
    [ -z "$QT_IM_MODULE" ] && export QT_IM_MODULE=ibus
    [ -z "$GTK_IM_MODULE" ] && export GTK_IM_MODULE=ibus
  fi
}

setup_ime_env

if [ -z "$XDG_DOWNLOAD_DIR" ]; then
  export XDG_DOWNLOAD_DIR="$HOME/Downloads"
fi

if [ -z "$XDG_DOCUMENTS_DIR" ]; then
  export XDG_DOCUMENTS_DIR="$HOME/Documents"
fi

ulimit -c 0

export QT_QPA_PLATFORM=xcb
export QT_PLUGIN_PATH=/app/extra/dingtalk/current_version
cd /app/extra/dingtalk/current_version

exec ./com.alibabainc.dingtalk --no-sandbox --enable-logging=stderr --v=1 --disable-gpu --disable-gpu-compositing "$@"
