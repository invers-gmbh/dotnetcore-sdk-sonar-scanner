FROM mcr.microsoft.com/dotnet/sdk:5.0

RUN apt update

# Install Java
RUN apt install --yes default-jdk
RUN java -version

# Trying to fix sonarscanner problems
ENV DOTNET_ROLL_FORWARD=Major 
ENV PATH="$PATH:/root/.dotnet/tools"

# Install dotnet-sconarscanner
RUN dotnet tool install -g dotnet-sonarscanner
RUN dotnet tool install -g dotnet-reportgenerator-globaltool

# Install libgdiplus
RUN apt install -y libgdiplus libc6-dev \
    && ln -s /usr/lib/libgdiplus.so /usr/lib/gdiplus.dll

# Cleanup
RUN apt -q autoremove \
    && apt -q clean -y \
    && rm -rf /var/lib/apt/lists/* /var/cache/apt/*.bin
