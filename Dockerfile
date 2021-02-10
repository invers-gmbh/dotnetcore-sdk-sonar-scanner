FROM mcr.microsoft.com/dotnet/sdk:5.0-focal

#  Install Java
RUN apt-get update \
    && apt-get install --yes default-jdk

# Trying to fix sonarscanner problems
ENV DOTNET_ROLL_FORWARD=Major 
ENV PATH="$PATH:/root/.dotnet/tools"

# Install dotnet-sconarscanner
RUN dotnet tool install -g dotnet-sonarscanner
RUN dotnet tool install -g dotnet-reportgenerator-globaltool