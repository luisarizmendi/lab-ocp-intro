FROM quay.io/openshifthomeroom/workshop-dashboard:5.0.0

USER root

COPY . /tmp/src

RUN rm -rf /tmp/src/.git* && \
    chown -R 1001 /tmp/src && \
    chgrp -R 0 /tmp/src && \
    chmod -R g+w /tmp/src && \
    yum install -y mariadb source-to-image tree python2-httpie procps-ng  && \
    pip install yq && \
    curl -L -o hey https://storage.googleapis.com/hey-release/hey_linux_amd64 && \
    chmod +x hey && \
    mv hey /usr/bin/hey && \
    curl -L -o stern https://github.com/wercker/stern/releases/download/1.11.0/stern_linux_amd64 && \
    chmod +x stern && \
    mv stern /usr/bin/stern && \
    curl -L -o kn https://github.com/knative/client/releases/download/v0.2.0/kn-linux-amd64 && \
    chmod +x kn && \
    mv kn /usr/bin/kn 

ENV TERMINAL_TAB=split

USER 1001

RUN /usr/libexec/s2i/assemble
