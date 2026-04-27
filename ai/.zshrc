export GODYL_OUTPUT_DIR=/usr/local/bin

# Load shared shell configuration
SHELL_RC=${HOME}/.dotfiles/.shellrc
[ -f ${SHELL_RC} ] && source ${SHELL_RC}

alias copilot="copilot --allow-all-tools"
alias gemini="gemini --yolo"

claudep() {
  export ANTHROPIC_BASE_URL=http://localhost:4141
  export ANTHROPIC_AUTH_TOKEN=dummy
  export ANTHROPIC_MODEL=claude-opus-4.6
  export ANTHROPIC_DEFAULT_SONNET_MODEL=claude-sonnet-4.6
  export ANTHROPIC_DEFAULT_HAIKU_MODEL=claude-haiku-4.5
  export ANTHROPIC_DEFAULT_OPUS_MODEL=claude-opus-4.6
  export DISABLE_NON_ESSENTIAL_MODEL_CALLS=1
  export CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC=1
  export CLAUDE_CODE_ATTRIBUTION_HEADER=0

  TOKEN=""
  if ! curl -s http://localhost:4141 2>/dev/null | grep -q "Server running"; then
      nohup copilot-api start ${TOKEN} &> /tmp/copilot-api & disown
  fi

  claude

  unset ANTHROPIC_BASE_URL
  unset ANTHROPIC_AUTH_TOKEN
  unset ANTHROPIC_MODEL
  unset ANTHROPIC_DEFAULT_SONNET_MODEL
  unset ANTHROPIC_DEFAULT_HAIKU_MODEL
  unset ANTHROPIC_DEFAULT_OPUS_MODEL
  unset DISABLE_NON_ESSENTIAL_MODEL_CALLS
  unset CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC
  unset CLAUDE_CODE_ATTRIBUTION_HEADER
}

# if SHELL is zsh
if [ -n "$ZSH_VERSION" ]; then
  unsetopt HIST_SAVE_BY_COPY
  setopt HIST_FCNTL_LOCK
fi
