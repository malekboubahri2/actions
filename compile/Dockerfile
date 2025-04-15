# Container image that runs your code
FROM ubuntu:latest

# Installs prerequisites (WGET and BZIP2 utilities)
#  NOTE: --yes 'Automatic yes to prompts during install'
RUN apt-get update --quiet=3 && apt-get install --quiet=3 --yes wget
RUN apt-get update --quiet=3 && apt-get install --quiet=3 --yes bzip2


# Copies code file from your action repository to the filesystem path `/` of
#  the container
COPY entrypoint.sh /entrypoint.sh

# Sets code file executable
RUN chmod +x /entrypoint.sh

# Code file to execute when the docker container starts up (`entrypoint.sh`)
ENTRYPOINT ["/entrypoint.sh"]