# Base image
FROM golang:1.20.0-bullseye as base

# Install necessary tools and dependencies in a single RUN command
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        graphviz \
        curl \
        gnupg && \
    curl -LO https://dl.k8s.io/release/v1.23.0/bin/linux/amd64/kubectl && \
    install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl && \
    rm kubectl && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install Krew and set PATH
RUN set -x; cd "$(mktemp -d)" && \
    OS="$(uname | tr '[:upper:]' '[:lower:]')" && \
    ARCH="$(uname -m | sed -e 's/x86_64/amd64/' -e 's/\(arm\)\(64\)\?.*/\1\2/' -e 's/aarch64$/arm64/')" && \
    KREW="krew-${OS}_${ARCH}" && \
    curl -fsSLO "https://github.com/kubernetes-sigs/krew/releases/latest/download/${KREW}.tar.gz" && \
    tar zxvf "${KREW}.tar.gz" && \
    ./"${KREW}" install krew && \
    echo "export PATH=\"\${KREW_ROOT:-\$HOME/.krew}/bin:\$PATH\"" | tee -a /root/.bashrc && \
    rm -rf "${KREW}.tar.gz" "${KREW}"

# Set PATH environment variable and install kubectl krew plugin
ENV PATH="/root/.krew/bin:/usr/local/bin:$PATH"
RUN kubectl krew install oidc-login

# Verify installations
RUN kubectl version --client && \
    dot -V

# Final image
FROM base as final

# Set working directory and copy the script
WORKDIR /workspace
COPY run.sh /workspace/
RUN chmod +x /workspace/run.sh

# Default command
ENTRYPOINT ["/workspace/run.sh"]
