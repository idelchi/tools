# Load shared shell configuration
SHELL_RC=${HOME}/.dotfiles/.shellrc
[ -f ${SHELL_RC} ] && source ${SHELL_RC}

alias copilot="copilot --allow-all-tools"
alias gemini="gemini --yolo"

claudep() {
  if ! curl -s http://localhost:4141 2>/dev/null | grep -q "Server running"; then
      nohup copilot-api start &> /tmp/copilot-api & disown
  fi

  ANTHROPIC_BASE_URL=http://localhost:4141 \
  ANTHROPIC_AUTH_TOKEN=dummy \
  ANTHROPIC_MODEL=claude-sonnet-4.5 \
  ANTHROPIC_DEFAULT_SONNET_MODEL=claude-sonnet-4.5 \
  ANTHROPIC_SMALL_FAST_MODEL=claude-sonnet-4.5 \
  ANTHROPIC_DEFAULT_HAIKU_MODEL=claude-sonnet-4.5 \
  DISABLE_NON_ESSENTIAL_MODEL_CALLS=1 \
  CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC=1 \
  claude
}

# if SHELL is zsh
if [ -n "$ZSH_VERSION" ]; then
  unsetopt HIST_SAVE_BY_COPY
  setopt HIST_FCNTL_LOCK
fi
