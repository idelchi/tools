#!/usr/bin/env bash
set -euo pipefail

: "${HOME:?HOME must be set}"

install -d -m 0755 "${HOME}/.local/share/zinit/zinit.git"
git clone --depth=1 "https://github.com/zdharma-continuum/zinit.git" "${HOME}/.local/share/zinit/zinit.git"
git clone --depth=1 "https://github.com/zdharma-continuum/fast-syntax-highlighting.git" "${HOME}/.local/share/zinit/plugins/zdharma-continuum---fast-syntax-highlighting"
git clone --depth=1 "https://github.com/zsh-users/zsh-autosuggestions.git" "${HOME}/.local/share/zinit/plugins/zsh-users---zsh-autosuggestions"
git clone --depth=1 "https://github.com/robbyrussell/oh-my-zsh.git" "${HOME}/.local/share/zinit/plugins/robbyrussell---oh-my-zsh"
git clone --depth=1 "https://github.com/zsh-users/zsh-history-substring-search.git" "${HOME}/.local/share/zinit/plugins/zsh-users---zsh-history-substring-search"
install -d -m 0755 "${HOME}/.local/share/zinit/snippets/omz-git"
curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/plugins/git/git.plugin.zsh -o "${HOME}/.local/share/zinit/snippets/omz-git/git.plugin.zsh"

