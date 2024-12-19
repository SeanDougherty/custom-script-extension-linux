FROM mcr.microsoft.com/azurelinux/base/core:3.0
RUN tdnf install lsof make zip golang awk ca-certificates -y

# Remove from final version, included for debug purposes
RUN tdnf install vim -y

ENV GOPATH="/go"
WORKDIR /usr/local/build
COPY . .
RUN make bundle
WORKDIR /
RUN rm -rf /usr/local/build

# RUN rm -f /var/lib/waagent/Microsoft.Azure.Extensions.CustomScript-2.1.10/status

# Default command to keep the container running
# ENTRYPOINT ["/bin/bash", "-c", "tail -f /dev/null"]
ENTRYPOINT ["/bin/bash"]
