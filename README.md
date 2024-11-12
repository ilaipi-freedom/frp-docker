## 效果

#### http(s)

通过服务器端和客户端的容器启动，实现把一个域名的根域名(ilaipi.com)和二级通配域名

穿透到客户端的 `80/443`。

因为这个是把配置的所有信息，都通过actions打包的镜像中，所以镜像需要保存到私有仓库中。

建议自己搭建一个私有仓库，参考 [部署nexus3](https://ilaipi.com/archives/768)。或者有其它的私有仓库可以使用，都是可以的。

我本来用的是华为云的镜像仓库，很好用，还免费。但是华为云的镜像服务应该是不支持多架构的镜像，所以只能自己搭建了镜像仓库。

如果需要实现其它的穿透效果，需要自行查看 [frp文档](https://github.com/fatedier/frp)，对应修改配置后进行构建即可。

## Environment variables

可在 Environment variables 中指定变量有：

```
FRP_VERSION 默认: 0.53.2

DOCKER_IMAGE_NAME_FRPC frpc镜像名称 必填
DOCKER_IMAGE_NAME_FRPS frps镜像名称 必填
ROOT_DOMAIN_NAME 如果是http服务，这个应该是必填的
```

## Environment secrets

可在 Environment secrets 中指定的变量有：

```
SERVER_HOST 就是云服务器的地址 必填
SERVER_PORT frp服务监听的端口 默认是 7000  建议修改
AUTH_TOKEN  frp服务的认证token 建议必填 没有测试不填的情况 如果非不想填，可能需要把 frp*.toml 中的 `auth.token` 这行给删掉

# 这几个是frp dashboard的参数，可以在 frps 容器查看具体的值，每次更换服务器不需要改这里
FRP_DASHBOARD_ADDR dashboard的host，默认是 0.0.0.0 非特殊情况应该都不需要填
FRP_DASHBOARD_PORT dashboard的端口，默认是 7500  建议修改
FRP_DASHBOARD_USERNAME dashboard的用户名 默认是 admin  建议修改
FRP_DASHBOARD_PASSWORD dashboard的密码 默认是 admin  建议修改
```

## 部署

已加入到 action 自动执行，参考： `.github/workflows/docker-image.yml`


## 更换服务器说明

Tips: 一般更换服务器，客户端需要做的只有修改服务器ip，尽量保持全部参数不改，就不需要修改其它任何参数。

- [ ] 如果修改了ip，需要先把域名解析修改一下记录值，指向新的服务器ip
- [ ] 新服务器开放frps端口，在 `frpc` 容器内可以查看端口号，

```
docker exec -it frpc sh

cat /etc/frp/frpc.toml
```

- [ ] 修改`secrets.SERVER_HOST`
