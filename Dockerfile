FROM mysql:8.0.30-debian as base
ARG python_version=3.9

RUN apt-get update && apt-get -y install python${python_version}
RUN apt-get -y install python-is-python3
RUN apt-get -y install python3-pip
COPY requirements.txt /build
WORKDIR pip install -r requirements.txt

# Setup Build Machine
FROM base AS build_machine
RUN apt-get -y install git curl wget ca-certificates gnupg lsb-release
# docker
RUN apt-get -y install docker.io
# dbmate
RUN curl -fsSL -o /usr/local/bin/dbmate https://github.com/amacneil/dbmate/releases/latest/download/dbmate-linux-amd64
RUN chmod +x /usr/local/bin/dbmate

# Setup DevEnv
FROM build_machine AS dev_env
RUN apt-get -y install zsh net-tools
RUN echo Y | sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
