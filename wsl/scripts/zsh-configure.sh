#!/usr/bin/env bash
set -euo pipefail

user="${1:?missing user}"
HOME="/home/${user}"

ZINIT=${HOME}/.local/share/zinit

rm -rf ${ZINIT}
mkdir -p ${ZINIT}

install -d -m 0755 ${ZINIT}/zinit.git
git clone --depth=1 https://github.com/zdharma-continuum/zinit.git ${ZINIT}/zinit.git
git clone --depth=1 https://github.com/zdharma-continuum/fast-syntax-highlighting ${ZINIT}/plugins/zdharma-continuum---fast-syntax-highlighting
git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions ${ZINIT}/plugins/zsh-users---zsh-autosuggestions
git clone --depth=1 https://github.com/robbyrussell/oh-my-zsh.git ${ZINIT}/plugins/robbyrussell---oh-my-zsh
git clone --depth=1 https://github.com/zsh-users/zsh-history-substring-search ${ZINIT}/plugins/zsh-users---zsh-history-substring-search
install -d -m 0755 ${ZINIT}/snippets/omz-git
curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/plugins/git/git.plugin.zsh -o ${ZINIT}/snippets/omz-git/git.plugin.zsh

git config --global --add safe.directory "*"

mkdir -p ${HOME}/.config
