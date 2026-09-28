# TVHelper 家庭 PVE 自定义部署说明

## 项目定位

原项目为 `wukongdaily/tvhelper-docker`。本项目是基于原项目维护的自用 Fork，继续保留原项目的许可证、作者署名及相关版权信息。

本项目使用官方 v1.1.5 镜像作为基础。为保证构建基线稳定，根目录 Dockerfile 固定使用以下镜像 digest：

```text
wukongdaily/box@sha256:cf8384151c3face7fe51d55a8898b034d4a00dd71e0b6793a5464d2fe84b5066
```

## 自定义内容

本项目修改了 `shells/tv.sh` 中的 ADB 连接逻辑：

- 菜单允许输入 `IPv4:动态端口`。
- 只有仅输入 IPv4 地址时才默认使用端口 `5555`。
- 是否使用配对码由用户单独选择，不再根据电视型号推断。
- 使用完整的 `IPv4:端口` 执行 `adb connect`。
- 在 `adb devices` 中精确匹配完整地址，并区分 `device`、`unauthorized`、`offline` 和连接失败状态。

连接成功历史写在容器内的 `/tvhelper/shells/history`。该文件未单独持久化时，容器重建后可能丢失。电视的动态 ADB 端口发生变化时，需要重新输入新的完整地址。

## 部署环境

部署路径：

```text
PVE → LXC120（10.0.30.20）→ Portainer 原 Stack tvhelper
```

正式 Compose 文件位于仓库根目录：

```text
compose.yaml
```

当前使用的镜像标签为：

```text
tvhelper-custom:v1.1.5-port1
```

该镜像在 LXC120 本地构建，尚未发布到任何镜像仓库。

上传入口：

```text
http://10.0.30.20:15000
```

## 持久化目录

- 安装包目录 `/data` 映射到 LXC120 的 `/data/appdata/tvhelper/data`。
- ADB 密钥目录映射到 LXC120 的 `/data/appdata/tvhelper/adb`。
- 上述目录通过 PVE 的 `mp0` 挂载存放在 NVMe 上。

文档和仓库中不得写入密码、ADB 私钥或真实电视 IP。

## 构建命令

在 LXC120 中进入仓库根目录后执行：

```bash
docker build --pull=false -t tvhelper-custom:v1.1.5-port1 .
```

`--pull=false` 不强制更新基础镜像；本地已有对应镜像时可复用。本项目通过 Dockerfile 中的 digest 固定基础镜像：

```text
wukongdaily/box@sha256:cf8384151c3face7fe51d55a8898b034d4a00dd71e0b6793a5464d2fe84b5066
```

## Portainer 更新与回退

更新 Portainer Stack 时，应关闭“重新拉取镜像”，以使用 LXC120 本地构建的 `tvhelper-custom:v1.1.5-port1`。

需要回退时，将 Portainer 中 `tvhelper` Stack 的 YAML 恢复为已保存的原始 Compose。原版基础镜像可以按本文记录的固定 digest 重新确认。

## 验证状态

已经验证：

- 自定义镜像可以完成构建。
- 正式容器可以运行。
- `15000` 端口的上传页面可以打开。
- 原有安装包在容器中可见。
- 测试容器的 `15001` 上传成功，并已写入 `/data`。

仍待现场验证：

- TCL Q10L 的 ADB 授权及完整连接结果。
- 通过电视实际安装 APK。

在完成现场验证前，不应将 APK 安装描述为已经成功。
