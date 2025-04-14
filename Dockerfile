# Container image that runs your code
FROM ubuntu:latest

# Copies code file from your action repository to the filesystem path `/` of
#  the container
COPY entrypoint.sh /entrypoint.sh

# Sets code file executable
RUN chmod +x /entrypoint.sh

# Code file to execute when the docker container starts up (`entrypoint.sh`)
ENTRYPOINT ["/entrypoint.sh"]