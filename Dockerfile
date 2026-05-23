FROM ubuntu:26.04

# Prevent interactive prompts during installation
ENV DEBIAN_FRONTEND=noninteractive

# Install Perl and all required POPFile modules silently
RUN apt-get update -qq && apt-get install -y -qq \
    unzip \
    perl \
    libdbi-perl \
    libtime-parsedate-perl \
    libhtml-tagset-perl \
    libhtml-template-perl \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Set up directories
RUN mkdir -p /opt/popfile

# Copy the zip file downloaded by GitHub Actions into the container
COPY popfile-1.1.3.zip /tmp/popfile.zip

# Extract POPFile and clean up the zip
RUN unzip -q /tmp/popfile.zip -d /opt/popfile \
    && rm /tmp/popfile.zip

WORKDIR /opt/popfile

# Start POPFile and bind it to all interfaces on port 8080
CMD ["perl", "popfile.pl", "--host", "0.0.0.0"]
