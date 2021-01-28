FROM mcr.microsoft.com/dotnet/sdk:3.1-focal

# Register Microsoft key and product repository
RUN wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.asc.gpg \
    && mv microsoft.asc.gpg /etc/apt/trusted.gpg.d/ \
    && wget -q https://packages.microsoft.com/config/debian/10/prod.list \
    && mv prod.list /etc/apt/sources.list.d/microsoft-prod.list \
    && chown root:root /etc/apt/trusted.gpg.d/microsoft.asc.gpg \
    && chown root:root /etc/apt/sources.list.d/microsoft-prod.list

# added ca fix (https://github.com/NuGet/Home/issues/10491#issuecomment-768687027)
ADD http://ftp.us.debian.org/debian/pool/main/c/ca-certificates/ca-certificates_20210119_all.deb .
RUN dpkg -i ca-certificates_20210119_all.deb

RUN apt-get update && apt-get install -y \
	ca-certificates \
	&& update-ca-certificates \
	&& rm -rf /var/lib/apt/lists/*

# Install apt-transport-https, dotnet-sdk-5.0, Java
RUN apt-get update \
    && apt-get install apt-transport-https \
    && apt-get update \
    && apt-get install --yes dotnet-sdk-5.0 \
    && apt-get install --yes default-jdk

# Trying to fix sonarscanner problems
ENV DOTNET_ROLL_FORWARD=Major 
ENV PATH="$PATH:/root/.dotnet/tools"

# Install dotnet-sconarscanner
RUN dotnet tool install -g dotnet-sonarscanner
RUN dotnet tool install -g dotnet-reportgenerator-globaltool