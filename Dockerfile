FROM ubuntu:xenial

ARG user=jenkins
ARG group=jenkins
ARG uid=1000
ARG gid=1000
ARG JENKINS_AGENT_HOME=/home/${user}

ENV SWARM_CLIENT_VERSION="3.9" \
    COMMAND_OPTIONS="" \
    USER_NAME_SECRET="" \
    PASSWORD_SECRET="" \
    JENKINS_AGENT_HOME=${JENKINS_AGENT_HOME}

RUN groupadd -g ${gid} ${group} \
    && useradd -d "${JENKINS_AGENT_HOME}" -u "${uid}" -g "${gid}" -m -s /bin/bash "${user}"

WORKDIR "${JENKINS_AGENT_HOME}"

# Install Swarm Agent, Docker tools, Rancher CLI and Misc tools
RUN apt-get update && \
    apt-get install --no-install-recommends -y curl wget openssh-client openssl apt-transport-https ca-certificates software-properties-common && \
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add - && \
    add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" && \
    apt-get update && \
    apt-get install --no-install-recommends -y docker-ce-cli docker-compose && \
    rm -rf /var/lib/apt/lists/* && \
    curl -SL https://releases.rancher.com/cli/v0.6.10/rancher-linux-amd64-v0.6.10.tar.gz | tar --strip=2 -xzC /usr/bin/ && \
    wget --no-check-certificate -q https://repo.jenkins-ci.org/releases/org/jenkins-ci/plugins/swarm-client/${SWARM_CLIENT_VERSION}/swarm-client-${SWARM_CLIENT_VERSION}.jar -P ${JENKINS_AGENT_HOME} && \
    curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | bash

# Install JDK 8 (latest edition)
RUN apt-get -q update &&\
    DEBIAN_FRONTEND="noninteractive" apt-get -q install -y -o Dpkg::Options::="--force-confnew" --no-install-recommends software-properties-common &&\
    add-apt-repository -y ppa:openjdk-r/ppa &&\
    apt-get -q update &&\
    DEBIAN_FRONTEND="noninteractive" apt-get -q install -y -o Dpkg::Options::="--force-confnew" --no-install-recommends openjdk-8-jre-headless &&\
    apt-get -q clean -y && rm -rf /var/lib/apt/lists/* && rm -f /var/cache/apt/*.bin

# Install mono
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF

RUN echo "deb https://download.mono-project.com/repo/ubuntu stable-xenial main" > /etc/apt/sources.list.d/mono-xamarin.list \
  && apt-get update \
  && apt-get install -y mono-devel ca-certificates-mono fsharp mono-vbnc nuget git git-lfs libunwind8 libcurl3 \
  && rm -rf /var/lib/apt/lists/* \
  && apt-get -q clean -y && rm -rf /var/lib/apt/lists/* && rm -f /var/cache/apt/*.bin \
  && git lfs install

RUN apt-get update && apt-get install -y libicu-dev \
 && apt-get -q clean -y && rm -rf /var/lib/apt/lists/* && rm -f /var/cache/apt/*.bin \
 && mkdir /workspace

COPY run.sh /run.sh
RUN chmod +x /run.sh

ENTRYPOINT ["/run.sh"]
