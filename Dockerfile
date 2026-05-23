FROM ubuntu:26.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update -qq && apt-get install -y -qq \
    curl \
    unzip \
    perl \
    libdbi-perl \
    libtime-parsedate-perl \
    libhtml-tagset-perl \
    libhtml-template-perl \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /opt/popfile \
    && curl -L "https://downloads.sourceforge.net/project/popfile/popfile/popfile-1.1.3/popfile-1.1.3.zip" -o /tmp/popfile.zip \
    && unzip /tmp/popfile.zip -d /opt/popfile \
    && rm /tmp/popfile.zip

WORKDIR /opt/popfile

CMD ["perl", "popfile.pl", "--host", "0.0.0.0"]
