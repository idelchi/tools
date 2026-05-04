#!/usr/bin/env bash
set -euo pipefail

user="${1:?missing user}"
HOME="/home/${user}"
dir="${2:?missing dir}"

cat > "${HOME}/.zshrc" <<EOF
source ${dir}/.zshrc
EOF

cat > "${HOME}/.bashrc" <<EOF
source ${dir}/.zshrc
EOF

cat > "${HOME}/.gitconfig" <<EOF
[include]
    path = ${dir}/.gitconfig

[core]
    autocrlf = input
    eol = lf
EOF
