

```
docker-compose up mariadb
```

```
docker-compose run migrate
```

```
docker-compose up redis
```
# Instructions for K8s

- sites folder has prebuilt site related files
- mb.biograph.care // site name
- we need to copy sites folder while creating the images for Frappe worker and nginx 
- We also need to copy sites folder to this docker image as well : https://hub.docker.com/r/frappe/frappe-socketio

## Important Config Files

### common_site_config.json
### path: /home/frappe/frappe-bench/sites/

- Contains all params for Redis connections etc

```
{
 "background_workers": 1,
 "db_host": "mariadb",
 "file_watcher_port": 6787,
 "frappe_user": "frappe",
 "gunicorn_workers": 13,
 "live_reload": true,
 "maintenance_mode": 0,
 "pause_scheduler": 0,
 "rebase_on_pull": false,
 "redis_cache": "redis://redis-cache:6379",
 "redis_queue": "redis://redis-queue:6379",
 "redis_socketio": "redis://redis-socketio:6379",
 "restart_supervisor_on_update": false,
 "restart_systemd_on_update": false,
 "serve_default_site": true,
 "shallow_clone": true,
 "socketio_port": 9000,
 "use_redis_auth": false,
 "webserver_port": 8000
} 

```


### site_config.json
### path: /home/frappe/frappe-bench/sites/mb.biograph.care

```
{
 "db_name": "yyyyyyyyyyyyyyyyyyyy",
 "db_password": "xxxxxxxxxxxxxxx",
 "db_type": "mariadb",
 "encryption_key": "AuZ2rvEV6h1qXnWN4ugj5_o7ERWrhIKF5Rzaus-przY=",
 "server_script_enabled": true
}
 ```

## Migrating the db schema after cluster deployment

- 1. Login to the frappe worker container and run the following command

```
bench --site mb.biograph.care migrate
```

### Introduction

- This repo is based on official frappe_docker documentation to build [custom apps](https://github.com/frappe/frappe_docker/blob/main/custom_app/README.md).
- Fork this repo to build your own image with ERPNext and list of custom Frappe apps.
- Change the `frappe` and `erpnext` versions in `base_versions.json` to use them as base. These values correspond to tags and branch names on the github frappe and erpnext repo. e.g. `version-13`, `v13.25.1`
- Change `ci/clone-apps.sh` script to clone your private and public apps. Read comments in the file to update it as per need. This repo will install following apps:
  - https://github.com/yrestom/POS-Awesome
  - https://github.com/frappe/wiki
- Change `images/backend.Dockerfile` to copy and install required apps with `install-app`.
- Change `images/frontend.Dockerfile` to install ERPNext if required.
- Change `docker-bake.hcl` for builds as per need.
- Workflows from `.github/workflows` will build latest or tagged images using GitHub. Change as per need.
- Runner will build images automatically and publish to container registry.
- Use `gitlab-ci.yml` in case of Gitlab CI.

### Manually Build images

Execute from root of app repo

Clone,

```shell
./ci/clone-apps.sh
```

Set environment variables,

- `FRAPPE_VERSION` set to use frappe version during building images. Default is `version-14`.
- `ERPNEXT_VERSION` set to use erpnext version during building images. Default is `version-14`.
- `VERSION` set the tag version. Default is `latest`.
- `REGISTRY_NAME` set the registry name. Default is `custom_app`.
- `BACKEND_IMAGE_NAME` set worker image name. Default is `custom_worker`.
- `FRONTEND_IMAGE_NAME` set nginx image name. Default is `custom_nginx`.

Build,

```shell
docker buildx bake -f docker-bake.hcl --load
```

Note:

- Use `docker buildx bake --load` to load images for usage with docker.
- Use `docker buildx bake --push` to push images to registry.
- Use `docker buildx bake --help` for more information.
- Change version in `version.txt` to build tagged images from the changed version.

## Notes to run docker-compose

1. `./ci/clone-apps.sh`
2. `docker buildx bake -f docker-bake.hcl`
1. `docker-compose up mariadb`
2. `docker-compose run migrate` (should exit with code 0)
3. `docker-compose up frontend`

## Latest installation notes to run docker-compose:

1. `./ci/clone-apps.sh` or Pull the latest medblocks/erpnext repo `git pull`
2.  Remove existing images `docker rmi $(docker images -a -q)` `docker rm -f $(docker ps -aq)`
3. `docker buildx bake  --no-cache --load`
4. `docker-compose pull`
5. `docker-compose down -v`
6. `docker-compose up mariadb redis-cache redis-queue redis-socketio`
7. `docker-compose run install-app`  --- (Need to execute only for fresh install of db and app)
8. `docker-compose run migrate` --- (Need to execute after installing app or on existing site to update json files)



