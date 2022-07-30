# AWS on Docker

## Overview

AWS のサービスをローカルで動かしたいときのサンプル

## Description

- dynamodb
- sqs
- s3

のコンテナをローカルで立ち上げます。

`docker compose up` 時に `docker/awscli/init.sh` が実行され、dynamodb のテーブル、sqs のキュー、s3 のバケットが作成されます。
