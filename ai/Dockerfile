FROM idelchi/devenv:latest AS godyl

USER root

RUN curl -sSL https://raw.githubusercontent.com/idelchi/godyl/refs/heads/main/install.sh | sh -s -- -d /usr/local/bin -v v0.1.8

ARG CACHE_BUST

ARG GODYL_TOOLS=/tmp/tools.yml

COPY tools.yml ${GODYL_TOOLS}
ARG GODYL_INSTALL_OUTPUT=/opt/godyl
ARG GODYL_ENV_FILE=/run/secrets/tokens.env
ARG GODYL_NO_VERIFY_CHECKSUM=true

ENV GOMODCACHE=/root/.cache/.go-mod
ENV GOCACHE=/root/.cache/.go

RUN --mount=type=secret,id=tokens.env,required \
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

ARG CACHE_BUST

RUN npm install -g @google/gemini-cli@latest
RUN npm install -g @openai/codex@latest
RUN npm install -g @anthropic-ai/claude-code@latest
RUN npm install -g @github/copilot@latest

RUN npm install -g @musistudio/claude-code-router@latest
RUN npm install -g copilot-api@latest

RUN rm -rf /tmp/.cache /tmp/.npm

USER ${USER}
WORKDIR /home/${USER}

COPY .zshrc ${HOME}/.zshrc

RUN cat ${HOME}/.zshrc >> ${HOME}/.bashrc

ENV TZ=Europe/Zurich

CMD [ "zsh" ]

COPY --from=godyl /opt/godyl /usr/local/bin

USER root
RUN echo "PATH=${PATH}" >> /etc/environment

USER ${USER}

RUN mkdir -p ${HOME}/.kube ${HOME}/.uv
