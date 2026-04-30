export DOTFILES="{{ getenv "DOTFILES" }}"

export PATH="/usr/local/go/bin:$PATH"

SHELL_RC="${DOTFILES}/.shellrc"
[ -f "${SHELL_RC}" ] && source "${SHELL_RC}"
