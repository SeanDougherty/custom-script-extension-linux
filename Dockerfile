FROM mcr.microsoft.com/azurelinux/base/core:3.0
RUN tdnf install lsof make zip golang awk ca-certificates util-linux -y

ENV GOPATH="/go"
WORKDIR /usr/local/build
COPY . .
RUN make bundle
WORKDIR /
RUN rm -rf /usr/local/build

# Default command to keep the container running
ENTRYPOINT ["/bin/bash", "-c", "while true; do sleep 10; done"]
# ENTRYPOINT ["/bin/bash"]
