# Load shared shell configuration
SHELL_RC=${HOME}/.dotfiles/.shellrc
[ -f ${SHELL_RC} ] && source ${SHELL_RC}

alias copilot="copilot --allow-all-tools"
alias gemini="gemini --yolo"

claudep() {
  copilot-api start &> /tmp/copilot-api &

  ANTHROPIC_BASE_URL=http://localhost:4141 \
  ANTHROPIC_AUTH_TOKEN=dummy \
  ANTHROPIC_MODEL=claude-sonnet-4.5 \
  ANTHROPIC_DEFAULT_SONNET_MODEL=claude-sonnet-4.5 \
  ANTHROPIC_SMALL_FAST_MODEL=claude-haiku-4.5 \
  ANTHROPIC_DEFAULT_HAIKU_MODEL=claude-haiku-4.5 \
  DISABLE_NON_ESSENTIAL_MODEL_CALLS=1 \
  CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC=1 \
  claude
}

alias server="copilot-api start &> /tmp/copilot-api &"
