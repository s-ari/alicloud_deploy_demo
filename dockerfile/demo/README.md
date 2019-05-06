# Docker イメージ作成

TerraformとPackerをインストールしたDockerイメージを作成します。

## Dockerイメージのビルド

```
cd alicloud_deploy_demo/dockerfile/demo/
docker build -t arimas/alicloud_deploy_demo .
```

## コンテナの起動

```
docker run -it --name demo arimas/alicloud_deploy_demo /bin/bash
```
