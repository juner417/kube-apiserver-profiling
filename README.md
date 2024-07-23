# kube-api-profiling
* kubernetes apiserver profiling
* Tools for profiling kube apiserver
* This was containerized.
* I referred to the link below.
* [References](https://github.com/kubernetes/kubernetes/issues/111699)
* [Similar issue - large list processing](https://github.com/kubernetes/kubernetes/issues/114276)
* [Similar issue - watch request processing](https://github.com/kubernetes/kubernetes/pull/85410)

# pre-requisite
```bash
# install task binary
brew install go-task
```

# Build
```bash
git clone https://github.com/juner417/kube-apiserver-profiling.git
cd kube-apiserver-profiling

COMMIT_HASH=$(git rev-parse --short HEAD 2>/dev/null || echo "latest")

task build -- REPOSITORY_NAME=YOUR-REPO-NAME COMMIT_HASH=$COMMIT_HASH
```

# Run
```bash
COMMIT_HASH=$(git rev-parse --short HEAD 2>/dev/null || echo "latest")

task run -- REPOSITORY_NAME=YOUR-REPO-NAME COMMIT_HASH=$COMMIT_HASH
```

# Teardown
```bash
COMMIT_HASH=$(git rev-parse --short HEAD 2>/dev/null || echo "latest")

task clean -- REPOSITORY_NAME=YOUR-REPO-NAME COMMIT_HASH=$COMMIT_HASH
```

# Access profiling ui
* http://localhost:6061
* http://localhost:6062
