FROM idelchi/devenv:latest AS godyl

USER root

RUN curl -sSL https://raw.githubusercontent.com/idelchi/godyl/refs/heads/main/install.sh | sh -s -- -d /usr/local/bin -v v0.2.2

ARG CACHE_BUST

ARG GODYL_TOOLS=/tmp/tools.yml

COPY tools.yml ${GODYL_TOOLS}
ARG GODYL_INSTALL_OUTPUT=/opt/godyl
ARG GODYL_ENV_FILE=/run/secrets/secrets.env
ARG GODYL_NO_VERIFY_CHECKSUM=true

ENV GOMODCACHE=/root/.cache/.go-mod
ENV GOCACHE=/root/.cache/.go

RUN --mount=type=secret,id=secrets.env,required \
    --mount=type=cache,target=${GOMODCACHE} \
    --mount=type=cache,target=${GOCACHE} \
    godyl update --pre --force && \
    godyl -v install

FROM idelchi/devenv:latest

USER root

RUN apt-get update && apt-get install --no-install-recommends -y \
    zsh \
    nano \
    tree \
    net-tools \
    telnet \
    lsof \
    iproute2 \
    poppler-utils \
    rsync \
    xxd \
    gettext-base \
    dnsutils \
    && rm -rf /var/lib/apt/lists/*

ARG USER=user

USER ${USER}
WORKDIR /home/${USER}

ARG HOME=/home/${USER}

RUN mkdir -p ${HOME}/.local/share/zinit

RUN set -eux; \
    install -d -m 0755 ${HOME}/.local/share/zinit/zinit.git; \
    git clone --depth=1 https://github.com/zdharma-continuum/zinit.git ${HOME}/.local/share/zinit/zinit.git; \
    git clone --depth=1 https://github.com/zdharma-continuum/fast-syntax-highlighting \
    ${HOME}/.local/share/zinit/plugins/zdharma-continuum---fast-syntax-highlighting; \
    git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions \
    ${HOME}/.local/share/zinit/plugins/zsh-users---zsh-autosuggestions; \
    git clone --depth=1 https://github.com/robbyrussell/oh-my-zsh.git \
    ${HOME}/.local/share/zinit/plugins/robbyrussell---oh-my-zsh; \
    git clone --depth=1 https://github.com/zsh-users/zsh-history-substring-search \
    ${HOME}/.local/share/zinit/plugins/zsh-users---zsh-history-substring-search; \
    install -d -m 0755 ${HOME}/.local/share/zinit/snippets/omz-git; \
    curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/plugins/git/git.plugin.zsh \
    -o ${HOME}/.local/share/zinit/snippets/omz-git/git.plugin.zsh

WORKDIR /tmp
RUN git config --global --add safe.directory /home/${USER}/ws

USER root

RUN curl -fsSL https://claude.ai/install.sh | bash
RUN curl -fsSL https://gh.io/copilot-install | bash
RUN npm install -g @google/gemini-cli@latest
RUN npm install -g @openai/codex@latest
# RUN npm install -g @openai/codex@latest --prefix /usr/local/lib/oss
# RUN ln -s /usr/local/lib/oss/bin/codex /usr/local/bin/codex-oss

RUN npm install -g @kilocode/cli@latest

RUN npm install -g @musistudio/claude-code-router@latest
RUN npm install -g copilot-api@latest

RUN npm install -g @qwen-code/qwen-code@latest
RUN npm install -g @vibe-kit/grok-cli@latest
RUN curl -LsSf https://mistral.ai/vibe/install.sh | bash

RUN npm install -g opencode-ai@latest
RUN npm install -g @charmland/crush
RUN npm install -g @nanocollective/nanocoder

RUN curl -fsSL https://github.com/peakflames/claude-print/releases/latest/download/claude-print-linux-amd64 -o /usr/local/bin/claude-print && chmod +x /usr/local/bin/claude-print

RUN rm -rf /tmp/.cache /tmp/.npm

USER ${USER}
WORKDIR /home/${USER}

RUN go install golang.org/x/tools/cmd/deadcode@latest

RUN go install golang.org/x/tools/gopls@latest

COPY .zshrc ${HOME}/.zshrc

RUN cat ${HOME}/.zshrc >> ${HOME}/.bashrc

ENV TZ=Europe/Zurich

CMD [ "zsh" ]

COPY --from=godyl /opt/godyl /usr/local/bin

USER root

RUN ln -s /usr/local/bin/krew /usr/local/bin/kubectl-krew

COPY --from=docker:cli           /usr/local/bin/docker           /usr/local/bin/docker
COPY --from=docker/buildx-bin    /buildx                         /usr/libexec/docker/cli-plugins/docker-buildx
COPY --from=docker/compose-bin   /docker-compose                 /usr/libexec/docker/cli-plugins/docker-compose

# Create Docker group and add user
ARG DOCKER_GROUP=docker
ARG DOCKER_GID=0
RUN groupadd -for -g ${DOCKER_GID} ${DOCKER_GROUP} && \
    usermod -aG ${DOCKER_GID} user

RUN apt-get update && apt-get install -y \
    podman \
    && rm -rf /var/lib/apt/lists/*

RUN echo "user:100000:65536" >> /etc/subuid && \
    echo "user:100000:65536" >> /etc/subgid

RUN echo "PATH=${PATH}" >> /etc/environment
RUN chown -R ${USER}:${USER} ${HOME}

USER ${USER}

RUN mkdir -p ${HOME}/.kube ${HOME}/.uv  ${HOME}/.local/state/k9s ${HOME}/.kube/cache/oidc-login

RUN mkdir -p ${HOME}/.ssh ${HOME}/.ssh/sockets

USER ${USER}
RUN kubectl krew install oidc-login
ENV PATH="${HOME}/.krew/bin:${PATH}"

COPY --chown=${USER}:${USER} .ssh ${HOME}/.ssh
RUN chmod 700 ${HOME}/.ssh
RUN chmod 600 ${HOME}/.ssh/*
RUN chmod 700 ${HOME}/.ssh/sockets
