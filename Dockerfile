FROM ubuntu:26.04

# Prevent interactive prompts during installation
ENV DEBIAN_FRONTEND=noninteractive

# Install Perl, unzip, and dos2unix to fix Windows line endings
RUN apt-get update -qq && apt-get install -y -qq \
    unzip \
    dos2unix \
    perl \
    libdbi-perl \
    libtime-parsedate-perl \
    libhtml-tagset-perl \
    libhtml-template-perl \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Set up directories
RUN mkdir -p /opt/popfile

# Copy the local zip file from the repository into the container
COPY popfile-1.0.1.zip /tmp/popfile.zip

# Extract POPFile, convert Windows line endings to Linux, and clean up
RUN unzip -q /tmp/popfile.zip -d /opt/popfile \
    && rm /tmp/popfile.zip \
    && find /opt/popfile -type f -name "*.pl" -exec dos2unix {} + \
    && find /opt/popfile -type f -name "*.pm" -exec dos2unix {} +

WORKDIR /opt/popfile

# Start POPFile and bind it to all interfaces on port 8080
CMD ["perl", "popfile.pl", "--host", "0.0.0.0"]
