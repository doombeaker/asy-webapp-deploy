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

# Install Node 16.13.1 via n version manager
RUN npm install -g n \
    && n 16.13.1 \
    && npm config set registry https://registry.npmmirror.com \
    && rm -rf /usr/local/n/versions/node/* /tmp/*

# Switch to non-root user
USER $USERNAME

COPY --chown=$USERNAME:$USERNAME asy-app/package.json /home/$USERNAME/asy-app/package.json
RUN cd /home/$USERNAME/asy-app && npm install

COPY --chown=$USERNAME:$USERNAME asy-app /home/$USERNAME/asy-app
RUN cd /home/$USERNAME/asy-app && make

WORKDIR /home/$USERNAME/asy-app
EXPOSE 80
CMD ["make", "run"]
