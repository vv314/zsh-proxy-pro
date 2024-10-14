#######################################################
# zsh-proxy-pro
# An oh-my-zsh plugin for display proxy status.
# 
# https://github.com/vv314/zsh-proxy-pro
# 
# USAGE: 
#   proxy_pro [OPTION] [ARGUMENT]
#
#   Options:
#     -o  enable the proxy
#     -c  configure proxy
#           e.g. proxy_pro -c http 127.0.0.1:6152
#           e.g. proxy_pro -c socks5 127.0.0.1:6153
#     -q  quit the proxy
#     -s  show the proxy status
#     -h  show the help
# 
# ENVIRONMENT VARIABLES:
#   PROXY_PROMPT_SYMBOL -> proxy status symbol (default: 🌐)
#######################################################
PROXY_PROMPT_SYMBOL="🌐"

mkdir -p "${ZDOTDIR:-${HOME}}/.zsh-proxy-pro"

__proxy_pro_enable() {
  local config_dir="${ZDOTDIR:-${HOME}}/.zsh-proxy-pro"
  local http_config="$config_dir/http"
  local socks5_config="$config_dir/socks5"

  if [[ ! -f "$http_config" || ! -f "$socks5_config" || -z $(cat "$http_config") || -z $(cat "$socks5_config") ]]; then
    echo "Please configure the proxy first."
    echo ""
    __proxy_pro_usage -c
    return 1
  fi

  local http_proxy_val=$(cat "$http_config")
  local socks5_proxy_val=$(cat "$socks5_config")

  # Set HTTP proxy
  export http_proxy=$http_proxy_val
  export HTTP_PROXY=$http_proxy_val

  # Set HTTPS proxy
  export https_proxy=$http_proxy_val
  export HTTPS_PROXY=$http_proxy_val

  # Set SOCKS5 proxy
  export all_proxy=$socks5_proxy_val
  export ALL_PROXY=$socks5_proxy_val

  if [[ -n "$http_proxy_val" || -n "$socks5_proxy_val" ]]; then
    echo "\033[32mTerminal proxy is enabled.\033[0m"
  else
    echo "Failed to enable terminal proxy"
    return 1
  fi
}

__proxy_pro_quit() {
  unset {http,https,all}_proxy {HTTP,HTTPS,ALL}_PROXY
  echo "Terminal proxy has been disabled"
}

__proxy_pro_usage() {
  local opt="$1"

  case "$opt" in
    -c)
      cat <<EOF
Usage: proxy_pro -c <http | socks5> <host:port>

Examples:
  proxy_pro -c http 127.0.0.1:6152
  proxy_pro -c socks5 127.0.0.1:6153
EOF
      ;;
    *)
      cat <<EOF
Usage: proxy_pro [OPTION] [ARGUMENT]

Options:
  -o  enable the proxy
  -c  configure proxy
        e.g. proxy_pro -c http 127.0.0.1:6152
        e.g. proxy_pro -c socks5 127.0.0.1:6153
  -q  quit the proxy
  -s  show the proxy status
  -h  show the help
EOF
      ;;
  esac
}

__proxy_pro_check_enabled() {
  [[ -n "$HTTP_PROXY" || -n "$HTTPS_PROXY" || -n "$ALL_PROXY" || -n "$http_proxy" || -n "$https_proxy" || -n "$all_proxy" ]]
}

__proxy_pro_status() {
  local config_dir="${ZDOTDIR:-${HOME}}/.zsh-proxy-pro"
  local http_config="$config_dir/http"
  local socks5_config="$config_dir/socks5"

  if __proxy_pro_check_enabled; then
    echo "\033[32mTerminal proxy is enabled.\033[0m"
  else
    echo "Terminal proxy is disabled."
  fi

  local http_proxy_val

  if [[ -f "$http_config" ]]; then
    http_proxy_val=$(cat "$http_config")
  fi

  local socks5_proxy_val

  if [[ -f "$socks5_config" ]]; then
    socks5_proxy_val=$(cat "$socks5_config")
  fi

  echo ""
  echo "Proxy Configuration:"
  printf "  %-12s    %s\n" http "${http_proxy_val:-not set}"
  printf "  %-12s    %s\n" socks5 "${socks5_proxy_val:-not set}"

  if __proxy_pro_check_enabled; then
    echo ""
    echo "Environment Variables:"

    for var in http_proxy HTTP_PROXY https_proxy HTTPS_PROXY all_proxy ALL_PROXY; do
      value=$(printenv $var)
      [ -n "$value" ] && printf "  %-12s    %s\n" "$var" "$value"
    done
  fi
}

__proxy_pro_configure() {
  local config_dir="${ZDOTDIR:-${HOME}}/.zsh-proxy-pro"

  if [[ -n "$2" && -n "$3" ]]; then
    case $2 in
      http)
        echo "http://$3" > "$config_dir/http"
        ;;
      socks5)
        echo "socks5://$3" > "$config_dir/socks5"
        ;;
      *)
        __proxy_pro_usage -c
        return 1
        ;;
    esac
  else
    __proxy_pro_usage -c
    return 1
  fi
}

__proxy_pro_prompt() {
  if __proxy_pro_check_enabled; then
    if [[ $PROMPT != *"$PROXY_PROMPT_SYMBOL"* ]]; then
      PROMPT="$PROXY_PROMPT_SYMBOL $PROMPT"
    fi
  else
    PROMPT="${PROMPT//$PROXY_PROMPT_SYMBOL /}"
  fi
}

proxy_pro() {
  case $1 in
    -c) __proxy_pro_configure "$@" ;;
    -o) __proxy_pro_enable ;;
    -q) __proxy_pro_quit ;;
    -s) __proxy_pro_status ;;
    -h|*) __proxy_pro_usage ;;
  esac
}

precmd_functions+=(__proxy_pro_prompt)