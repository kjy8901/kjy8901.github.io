---
layout:     post
title:      "kubectl build"
date:       2026-01-15
categories: blog
author:     권 진영 (gc757489@gmail.com)
tags:       k8s kubernetes kubectl
cover:      "/assets/757489_logo.png"
main:      "/assets/757489_logo.png"
---

## git clone, 원하는 버전 선택
`git clone https://github.com/kubernetes/kubernetes.git`
`git checkout v1.26.15`

## 필요한 부분 수정
`vim staging/src/k8s.io/kubectl/pkg/cmd/create/create.go`
- "staging/src/k8s.io/kubectl/pkg/cmd/apply/apply.go"
 - apply.go에 kubectl apply 수행할 때 작업 추가

## kubectl build
`make kubectl`

## 적용
`_output/local/go/bin/kubectl`
`./_output/local/bin/linux/amd64/kubectl`
`cp _output/local/go/bin/kubectl /usr/bin/kubectl`


- - -

## 참고
