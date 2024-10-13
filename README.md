# 🌐 zsh-proxy-pro

An oh-my-zsh plugin for managing and displaying proxy status.

## Installation

Clone this repository into the `oh-my-zsh` plugins directory:

```shell
git clone https://github.com/vv314/zsh-proxy-pro.git $ZSH_CUSTOM/plugins/zsh-proxy-pro
```

Add `zsh-proxy-pro` to your [plugins array](<(https://github.com/ohmyzsh/ohmyzsh/blob/master/templates/zshrc.zsh-template#L73)>) in your `zshrc` file:

```shell
plugins=(... zsh-proxy-pro)
```

## Usage

```
proxy_pro [OPTION] [ARGUMENT]
```

**Options:**

```
-o  enable the proxy
-c  configure proxy
-q  quit the proxy
-s  show the proxy status
-h  show the help
```

### Configure proxy

Usage: `proxy_pro -c <http | socks5> <host:port>`

Examples:

```shell
# Set http proxy
proxy_pro -c http 127.0.0.1:6152

# Set socks5 proxy
proxy_pro -c socks5 127.0.0.1:6153
```

### Enable proxy

```shell
proxy_pro -o
```

### Disable proxy

```shell
proxy_pro -q
```

### Print status

```shell
proxy_pro -s
```

Outputs:

```shell
# $ proxy_pro -s

Terminal proxy is enabled.

Configuration:
  http  ------  http://127.0.0.1:6152
  socks5  ----  socks5://127.0.0.1:6153

Proxy:
  http  ------  http://127.0.0.1:6152
  https  -----  http://127.0.0.1:6152
  all  -------  socks5://127.0.0.1:6153
```

### Customize Prompt

When the proxy is enabled, a prompt symbol `🌐` will be displayed. You can customize the icon using `PROXY_PROMPT_SYMBOL`.

To set this in your `.zshrc` file, add the following line:

```shell
export PROXY_PROMPT_SYMBOL="☻"
```

## Uninstallation

Remove the `zsh-proxy-pro` item from the plugins array.

Remove `zsh-proxy-pro` from disk:

```shell
rm -rf $ZSH_CUSTOM/plugins/zsh-proxy-pro ~/.zsh-proxy-pro
```
