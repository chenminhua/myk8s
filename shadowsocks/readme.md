helm repo add predatorray http://predatorray.github.io/charts
helm upgrade --install shadowsocks predatorray/shadowsocks \\n    --set service.type=LoadBalancer --set shadowsocks.password.plainText=1234qwer
