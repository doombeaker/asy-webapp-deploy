# Asymptote Web Application Deployment

https://github.com/vectorgraphics/asymptoteWebApplication provides the Web Application version of Asymptote with which one can create vector graphics remotely without any local installation.
This repository further uses docker to deploy that web application.

The deployment process is described below.

## 1. Clone the asymptote-server repository

Suppose you are in current repository directory, and then run commands below to clone origin asymptote-server repository: 

```shell
cd asy-backend \
    && git clone https://github.com/vectorgraphics/asymptote-server \
    && cd ..
```

## 2. Install the docker-compose

```shell
python3 -m pip install pip --upgrade \
&& python3 -m pip install docker-compose
```


## 3. Run the services

```shell
docker-compose up -d
```

## Trouble-shooting

- frotend port
The default port exposed to user is `9527` which can be set to other which can be set to other values by edit [nginx.conf](./nginx-frontend//nginx.conf):
```conf
    listen 9527;
```

- frontend authentication
The config above using `.htpasswd` whose user and password is "draw", "good" respectively. You can use `htpasswd` command to generate your own auth file. Or simply comment the two lines out in [nginx.conf](./nginx-frontend//nginx.conf) to disable auth:

```
    auth_basic "Restricted Content";
    auth_basic_user_file /etc/nginx/.htpasswd;
```
- `Command 'docker-compose' not found` error.
This usually happens because of pip binary path is not set to `PATH` variable. Fix it by adding `docker-compose` path to `PATH`, eg:

```shell
export PATH=~/.local/bin:$PATH
```