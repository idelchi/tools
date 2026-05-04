
ARG GO_VERSION=1.26.2
FROM golang:${GO_VERSION}-trixie AS tools

USER root

RUN curl -sSL https://raw.githubusercontent.com/idelchi/godyl/refs/heads/main/install.sh | sh -s -- -d /usr/local/bin -v v0.2.2

ARG CACHE_BUST

ARG GODYL_TOOLS=/tmp/tools.yml

COPY tools.yml ${GODYL_TOOLS}
ARG GODYL_INSTALL_OUTPUT=/opt/godyl/bin
ARG GODYL_ENV_FILE=/run/secrets/secrets.env
ARG GODYL_NO_VERIFY_CHECKSUM=true

ENV GOMODCACHE=/root/.cache/.go-mod
ENV GOCACHE=/root/.cache/.go

RUN --mount=type=secret,id=secrets.env,required \
    --mount=type=cache,target=${GOMODCACHE} \
    --mount=type=cache,target=${GOCACHE} \
    godyl update --pre --force && \
    godyl -v install

ENV GOPATH=/opt/godyl
RUN echo \
    golang.org/x/tools/cmd/deadcode@latest \
    golang.org/x/tools/gopls@latest \
    | xargs -n 1 go install

FROM ubuntu:26.04

ARG TARGETARCH
ARG DEBIAN_FRONTEND=noninteractive

ENV NPM_CONFIG_CACHE=/tmp/.npm
ENV XDG_CACHE_HOME=/tmp/.cache
ENV MYPY_CACHE_DIR=/tmp/.mypy_cache
ENV RUFF_CACHE_DIR=/tmp/.ruff_cache
ENV TASK_TEMP_DIR=/tmp/.task

USER root

COPY --from=docker:cli           /usr/local/bin/docker           /usr/local/bin/docker
COPY --from=docker/buildx-bin    /buildx                         /usr/libexec/docker/cli-plugins/docker-buildx
COPY --from=docker/compose-bin   /docker-compose                 /usr/libexec/docker/cli-plugins/docker-compose

RUN apt-get update && apt-get install --no-install-recommends -y \
    build-essential \
    clang \
    curl \
    wget \
    git \
    nodejs \
    npm \
    ca-certificates \
    graphviz \
    gettext-base \
    moreutils \
    iputils-ping \
    procps \
    bsdextrautils \
    vim-common \
    coreutils \
    tree \
    zsh \
    nano \
    net-tools \
    telnet \
    lsof \
    iproute2 \
    rsync \
    xxd \
    dnsutils \
    podman \
    git-lfs \
    netcat-openbsd \
    unzip \
    less \
    dash \
    busybox \
    && rm -rf /var/lib/apt/lists/*

RUN git lfs install --system

ARG AWS_CLI_ARCH=${TARGETARCH/amd64/x86_64}
ARG AWS_CLI_ARCH=${AWS_CLI_ARCH/arm64/aarch64}
RUN curl -fsSL https://awscli.amazonaws.com/awscli-exe-linux-${AWS_CLI_ARCH}.zip -o /tmp/awscliv2.zip && \
    unzip -q /tmp/awscliv2.zip -d /tmp && \
    /tmp/aws/install && \
    rm -rf /tmp/awscliv2.zip /tmp/aws

RUN mkdir -p /usr/share/keyrings && \
    wget -qO - https://releases.jfrog.io/artifactory/api/v2/repositories/jfrog-debs/keyPairs/primary/public | gpg --dearmor -o /usr/share/keyrings/jfrog.gpg && \
    echo "deb [signed-by=/usr/share/keyrings/jfrog.gpg] https://releases.jfrog.io/artifactory/jfrog-debs focal contrib" | tee /etc/apt/sources.list.d/jfrog.list && \
    apt-get update && apt-get install -y \
    jfrog-cli-v2-jf \
    && rm -rf /var/lib/apt/lists/*

RUN apt-get update && apt-get install --no-install-recommends -y \
    poppler-utils \
    postgresql-client \
    && rm -rf /var/lib/apt/lists/*

ARG INSTALL_POSTGRESQL_CLIENT_15=false

RUN if [ "${INSTALL_POSTGRESQL_CLIENT_15}" = "true" ]; then \
    apt-get update && apt-get install --no-install-recommends -y \
    postgresql-common \
    && /usr/share/postgresql-common/pgdg/apt.postgresql.org.sh -y \
    && apt-get update \
    && apt-get install --no-install-recommends -y \
    postgresql-client-15 \
    && rm -rf /var/lib/apt/lists/*; \
    fi

ENV TZ=Europe/Zurich
ENV STARSHIP_LOG=error
ENV TMPDIR=/tmp

ARG USER=user
ARG UID=1000
ARG GID=1000
ENV HOME=/home/${USER}
RUN usermod -l "${USER}" ubuntu && \
    groupmod -n "${USER}" ubuntu && \
    groupmod -g "${GID}" "${USER}" && \
    usermod -u "${UID}" -g "${GID}" -d "${HOME}" -m -c "${USER} account" -s /bin/bash "${USER}" && \
    chown -R "${UID}:${GID}" "${HOME}"

ARG DOCKER_GROUP=docker
ARG DOCKER_GID
RUN groupadd -for -g ${DOCKER_GID} ${DOCKER_GROUP} && \
    usermod -aG ${DOCKER_GROUP} ${USER}

ENV PATH="${HOME}/.krew/bin:${PATH}"
ENV PATH="${HOME}/.local/bin:${PATH}"

RUN echo "PATH=${PATH}" >> /etc/environment

# AI Tooling
RUN curl -fsSL https://claude.ai/install.sh | bash
# RUN npm install -g @anthropic-ai/claude-code
RUN npm install -g @openai/codex@latest
RUN npm install -g copilot-api@latest
RUN curl -fsSL https://github.com/peakflames/claude-print/releases/latest/download/claude-print-linux-amd64 -o /usr/local/bin/claude-print && chmod +x /usr/local/bin/claude-print

ARG OPTIONAL_CLI_AGENTS=true
RUN if [ "${OPTIONAL_CLI_AGENTS}" = "true" ]; then \
    npm install -g @google/gemini-cli@latest && \
    curl -fsSL https://gh.io/copilot-install | bash && \
    npm install -g @kilocode/cli@latest && \
    npm install -g @musistudio/claude-code-router@latest && \
    npm install -g @qwen-code/qwen-code@latest && \
    npm install -g @vibe-kit/grok-cli@latest && \
    curl -LsSf https://mistral.ai/vibe/install.sh | bash && \
    npm install -g opencode-ai@latest && \
    npm install -g @charmland/crush && \
    npm install -g @nanocollective/nanocoder; \
    fi

COPY --from=golang:1.26.2 /usr/local/go /usr/local/go
ENV PATH="/usr/local/go/bin:$PATH"

COPY --from=tools /opt/godyl/bin /usr/local/bin
ENV PATH="/usr/local/bin:${PATH}"
RUN ln -s /usr/local/bin/krew /usr/local/bin/kubectl-krew

RUN chown -R "${UID}:${GID}" "${HOME}"

RUN find /tmp -mindepth 1 -maxdepth 1 -exec rm -rf -- {} +

USER ${USER}
WORKDIR ${HOME}

RUN mkdir -p \
    ${HOME}/.local/share/zinit \
    ${HOME}/.config \
    ${HOME}/.cache \
    ${HOME}/.kube \
    ${HOME}/.uv \
    ${HOME}/.local/state/k9s \
    ${HOME}/.ssh \
    ${HOME}/.ssh/sockets \
    ${HOME}/.minikube \
    ${HOME}/.config/glab-cli

RUN git config --global core.autocrlf input && \
    git config --global core.eol lf && \
    git config --global --add safe.directory "*"

COPY --chown=${USER}:${USER} .zshrc ${HOME}/.zshrc
RUN echo "source ${HOME}/.zshrc" >> ${HOME}/.bashrc

RUN --mount=type=bind,source=zsh.sh,target=/tmp/zsh.sh \
    /tmp/zsh.sh

COPY --chown=${USER}:${USER} .ssh ${HOME}/.ssh
RUN chmod 700 ${HOME}/.ssh && \
    chmod 600 ${HOME}/.ssh/* && \
    chmod 700 ${HOME}/.ssh/sockets

ENTRYPOINT [ "" ]
CMD [ "zsh" ]
