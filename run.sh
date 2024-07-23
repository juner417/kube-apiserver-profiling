#!/bin/bash

if [ $(find ${HOME}/.kube/cache/oidc-login -type f | wc -l) -eq 0 ]; then
  echo "Please log with oidc-login on hostmachine"
  exit 1
fi 

echo "run kubectl proxy on background"
kubectl proxy --kubeconfig=/root/.kube/config &
sleep 3

go tool pprof -http=:6061 http://127.0.0.1:8001/debug/pprof/heap &
go tool pprof -http=:6062 http://127.0.0.1:8001/debug/pprof/allocs
