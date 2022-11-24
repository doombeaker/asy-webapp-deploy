FROM texlive/texlive:latest

# install apt depencies
RUN apt-get --allow-unauthenticated update \
    && apt-get --allow-unauthenticated  install -y dirmngr \
    && apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 3B4FE6ACC0B21F32 871920D1991BC93C

# apt-get based on mirrors
COPY ubuntu20_sources.list /etc/apt/sources.list

RUN apt-get update \
    && apt-get install -y sudo

# create user
ARG USERNAME=asymptote
ARG USER_UID=1000
ARG USER_GID=$USER_UID
RUN echo $USER_UID
RUN groupadd --gid $USER_GID $USERNAME \
   && useradd -s /bin/bash --uid $USER_UID --gid $USER_GID -m $USERNAME \
   && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
   && chmod 0440 /etc/sudoers.d/$USERNAME

# set language
RUN export LANGUAGE=en_US.UTF-8 && \
    export LANG=en_US.UTF-8 && \
    export LC_ALL=en_US.UTF-8

# set time
RUN ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
RUN echo 'Asia/Shanghai' >/etc/timezone

# set user
USER asymptote
WORKDIR /home/asymptote
RUN sudo chown -R asymptote:asymptote /tmp

# set node & npm
RUN sudo apt-get install -y npm \
    && sudo npm i -g n && sudo n 16.13.1 \
    && sudo rm -rf /usr/bin/node \
    && sudo ln -s /usr/local/bin/node /usr/bin/node \
    && npm config set registry https://registry.npm.taobao.org

# clean up
RUN sudo rm -rf /tmp/*

# run web app
COPY run-webapp.sh /home/asymptote

ENTRYPOINT ["sh"]
CMD ["run-webapp.sh"]
