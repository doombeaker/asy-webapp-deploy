FROM texlive/texlive:latest

# Switch to Aliyun Debian mirror for faster apt in China
RUN sed -i 's|deb.debian.org|mirrors.aliyun.com|g' /etc/apt/sources.list.d/debian.sources \
    && sed -i 's|security.debian.org|mirrors.aliyun.com|g' /etc/apt/sources.list.d/debian.sources

# Install apt dependencies
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        sudo \
        npm \
    && rm -rf /var/lib/apt/lists/*

# Create non-root user
ARG USERNAME=asymptote
ARG USER_UID=1000
ARG USER_GID=$USER_UID

RUN userdel -r texlive 2>/dev/null || true \
    && groupadd --gid $USER_GID $USERNAME 2>/dev/null || true \
    && useradd -s /bin/bash --uid $USER_UID --gid $USER_GID -m $USERNAME \
    && echo "$USERNAME ALL=(root) NOPASSWD:ALL" > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME

RUN apt-get update \
    && apt-get install -y --no-install-recommends locales \
    && sed -i '/en_US.UTF-8/s/^# //' /etc/locale.gen \
    && locale-gen \
    && rm -rf /var/lib/apt/lists/*

ENV LANGUAGE=en_US.UTF-8 \
    LANG=en_US.UTF-8 \
    LC_ALL=en_US.UTF-8 \
    LIBGS=/usr/lib/x86_64-linux-gnu/libgs.so.10 \
    ASYMPTOTE_PORT=80

# Set timezone
RUN ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && echo 'Asia/Shanghai' > /etc/timezone

ENV npm_config_registry=https://registry.npmmirror.com \
    N_NODE_MIRROR=https://npmmirror.com/mirrors/node

# Install Node 16.13.1 via n version manager
RUN npm install -g n \
    && n 16.13.1 \
    && rm -rf /usr/local/n/versions/node/* /tmp/*

# Switch to non-root user
USER $USERNAME

# ── UI: install deps (cached unless package.json changes) ──
COPY --chown=$USERNAME:$USERNAME asy-app/ui/package.json /home/$USERNAME/asy-app/ui/package.json
RUN cd /home/$USERNAME/asy-app/ui && npm install

# ── UI: build (asy icons + react) ──
COPY --chown=$USERNAME:$USERNAME asy-app/ui /home/$USERNAME/asy-app/ui
RUN cd /home/$USERNAME/asy-app/ui && make

# ── Server: install deps (cached unless package.json changes) ──
COPY --chown=$USERNAME:$USERNAME asy-app/server/package.json /home/$USERNAME/asy-app/server/package.json
RUN cd /home/$USERNAME/asy-app/server && npm install

# ── Server: copy source ──
COPY --chown=$USERNAME:$USERNAME asy-app/server /home/$USERNAME/asy-app/server

# ── Move UI build output to where server expects it ──
RUN mv /home/$USERNAME/asy-app/ui/build /home/$USERNAME/asy-app/build

RUN mkdir -p /home/$USERNAME/asy-app/clients /home/$USERNAME/asy-app/logs

RUN rm -rf /home/$USERNAME/asy-app/ui/node_modules /home/$USERNAME/asy-app/ui/src

WORKDIR /home/$USERNAME/asy-app
EXPOSE 80
CMD ["node", "server/server.js"]
