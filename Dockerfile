FROM jenkins/jenkins:lts

USER root

# Update all installed packages to their latest versions (good for security)
RUN apt-get update && apt-get upgrade -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install necessary packages for Docker and add Docker's GPG key and repository
RUN apt-get update && \
    apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common \
    wget && \
    curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian bookworm stable" > /etc/apt/sources.list.d/docker.list && \
    apt-get update && \
    apt-get install -y containerd.io docker-ce docker-ce-cli && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# --- CHANGE HERE ---
ARG MAVEN_VERSION=3.9.5
ADD https://archive.apache.org/dist/maven/maven-3/${MAVEN_VERSION}/binaries/apache-maven-${MAVEN_VERSION}-bin.tar.gz /opt/apache-maven-${MAVEN_VERSION}-bin.tar.gz
RUN tar -xzf /opt/apache-maven-${MAVEN_VERSION}-bin.tar.gz -C /opt/ && \
    rm /opt/apache-maven-${MAVEN_VERSION}-bin.tar.gz && \
    ln -s /opt/apache-maven-${MAVEN_VERSION} /opt/maven && \
    ln -s /opt/maven/bin/mvn /usr/local/bin
# --- END CHANGE ---

ENV MAVEN_HOME=/opt/maven

# Add jenkins user to the docker group
RUN usermod -aG docker jenkins

USER jenkins