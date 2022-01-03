https://docs.bitnami.com/tutorials/create-your-first-helm-chart/

## step1. helm create
```sh
helm create mychart
```

生成的代码中，最重要的部分在templates中，这里定义着你的service, deployment等等object的yaml。
helm runs each file in this dir through "go template" rendering engine。

```sh
helm install --dry-run --debug mc ./mychart
## --dry-run   simulate an install
```

#### Values
templates里面会用.Charts和.Values。.Values对象是helm charts的关键。默认配置在values.yaml中，在install的时候也可以通过--set来设置。

#### helpers and other funcs

The service.yaml template also makes use of partials defined in _helpers.tpl, as well as functions like replace. The Helm documentation has a deeper walkthrough of the templating language, explaining how functions, partials and flow control can be used when developing your chart.

## depoly

```sh
helm install mc ./mychart --set service.type=NodePort
```

## modify and deploy

```yaml
image:
repository: prydonius/todo
tag: 1.0.0
pullPolicy: IfNotPresent
```

```
helm lint ./mychart
helm install todo ./mychart --set service.type=NodePort
```

## package

```sh
helm package ./mychart
```