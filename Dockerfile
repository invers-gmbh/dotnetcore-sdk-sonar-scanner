FROM mcr.microsoft.com/dotnet/core/sdk:3.0

# Install libgdiplus
RUN apt-get update \
    && apt-get install -y libgdiplus libc6-dev \
    && ln -s /usr/lib/libgdiplus.so /usr/lib/gdiplus.dll

# Install dotnet-sonarscanner
RUN dotnet tool install --global dotnet-sonarscanner --version 4.7.1

# Cleanup
RUN apt-get -q autoremove \
    && apt-get -q clean -y \
    && rm -rf /var/lib/apt/lists/* /var/cache/apt/*.bin
