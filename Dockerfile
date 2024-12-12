FROM mcr.microsoft.com/azurelinux/base/core:3.0
RUN tdnf install lsof make zip golang awk ca-certificates -y
ENV GOPATH="/go"
WORKDIR /usr/local/build
COPY . .
RUN make bundle
WORKDIR /
RUN rm -rf /usr/local/build
ENTRYPOINT /bin/bash
# ENTRYPOINT echo "hello from containerized"
