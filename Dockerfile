FROM mcr.microsoft.com/dotnet/core/sdk:2.2

RUN apt-get update

# Install Java
RUN apt-get install --yes default-jdk
RUN java -version

ENV PATH="$PATH:/root/.dotnet/tools"

# Install dotnet-sconarscanner
RUN dotnet tool install -g dotnet-sonarscanner
RUN dotnet tool install -g dotnet-reportgenerator-globaltool

# Install libgdiplus
RUN apt-get install -y libgdiplus libc6-dev \
    && ln -s /usr/lib/libgdiplus.so /usr/lib/gdiplus.dll

# Cleanup
RUN apt-get -q autoremove \
    && apt-get -q clean -y \
    && rm -rf /var/lib/apt/lists/* /var/cache/apt/*.bin
