# builder

## init
```
cp .env.example .env
# modify file .env if necessary
chmod +x init.sh
./init.sh
# git status
```


## database

### up database db ( root / 12345678)
```
mysql -u root -p
    12345678
    show databases;
    create database db;
    grant all on db.* to 'root'@'localhost' identified by '12345678';
    flush privileges;
    quit
```

### remove database db ( root / 12345678)
```
mysql -u root -p
    12345678
    show databases;
    DROP SCHEMA IF EXISTS db;
    quit
```


## xdebug

### xdebug-docker-PhpStorm
```
#1. Simple setting:
#click phone -> Click "Accept"

2. Other way:
File -> Settings -> Languages & Frameworks -> PHP ->Servers -> Add (+)
->
Name: docker
Host: 127.0.0.1
Check "Use path mappings": Absolute path on the server - /var/www/html)
OK
->Start listening (click phone)
```

### xdebug-docker-VisualStudioCode
```
install extension: PHP Debug

Run (Ctrl+Shift+D) -> create a launch.json file -> PHP

#launch.json
{
    "version": "0.2.0",
    "configurations": [
        {
            "name": "Listen for XDebug",
            "type": "php",
            "request": "launch",
            "port": 9000,
            "cwd": "${workspaceRoot}",
            "pathMappings": {
                "/var/www/html": "${workspaceRoot}"
            },
            "ignore": [
                "**/vendor/**/*.php"
            ]
        }
    ]
}

-> Ctrl+S

-> Run -> Start Debugging (F5)
```


## docker & docker-compose

### manipulation by DOCKER-services (containers)
```
# --- docker-compose ---

# run services (containers)
docker-compose up 
# run all services (containers) in the background
docker-compose up -d 
# rebuild services (containers)
docker-compose up --build
# run command (php artisan key:generate) in service as user with current id
docker-compose exec --user $(id -u):$(id -g) app php artisan key:generate

# restart services (containers)
docker-compose restart 

# stop services (containers)
docker-compose stop 
# stop app-service
docker-compose stop app 

# remove services (containers)
docker-compose down 


# --- docker ---

# stop and remove all containers
docker stop $(docker ps -a -q) && docker rm $(docker ps -a -q) 
# remove all unused containers, networks, images (both dangling and unreferenced), and optionally, volumes.
docker system prune 
```
    
### install Docker
[Mac & Windows](https://www.docker.com/products/docker-desktop)

[Ubuntu](https://docs.docker.com/engine/install/ubuntu/)


## slang
- url - site.local
- ip - 127.93.17.11

## tips

### Dockerfile
```
RUN cat /etc/os-release
```
