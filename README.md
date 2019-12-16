# Supported tags and respective `Dockerfile` links

- [`dotnet-3.1` -> .net Core SDK 3.1](https://github.com/invers-gmbh/dotnetcore-sdk-sonar-scanner/blob/dotnet-3.1/Dockerfile)
- [`dotnet-2.2` -> .net Core SDK 2.2](https://github.com/invers-gmbh/dotnetcore-sdk-sonar-scanner/blob/dotnet-2.2/Dockerfile)
- [`dotnet-3.0` -> .net Core SDK 3.0](https://github.com/invers-gmbh/dotnetcore-sdk-sonar-scanner/blob/dotnet-3.0/Dockerfile)


# What's this image about?

Dockerimage with .net Core SDK and [SonarScanner](https://docs.sonarqube.org/latest/analysis/scan/sonarscanner/) used for CI/CD pipelines.

# Example usage

## Bitbucket Pipeline

### Repository Variables
- SONAR_URL (Base URL of your SonarQube, for SonarCloud use `https://sonarcloud.io`)
- SONAR_TOKEN (Token generated in SonarQube)
- SOLUTION_FILE (complete path to sln file, e.g. `/my-project/my_project.sln`)

### `bitbucket-pipelines.yml`
```
image: inverscom/dotnetcore-sdk-sonar-scanner:dotnet-3.0

definitions:
  services:
    docker:
      memory: 3072

pipelines:
  branches:
    "{dev,master}": 
      - step:
          name: Quality analysis to Sonarqube
          services:
            - docker
          caches:
            - dotnetcore
          script:
            - export DOTNET_ROLL_FORWARD=Major
            - export PATH="$PATH:/root/.dotnet/tools"
            - export PROJECT_NAME=$SOLUTION_FILE
            - dotnet test --collect:"XPlat Code Coverage" "/p:CollectCoverage=true"
            - reportgenerator "-reports:**/*.cobertura.xml" "-targetdir:results/coverage" "-reporttypes:SonarQube" "-assemblyfilters:-Ben.Demystifier;-FluentValidation*"
            - dotnet sonarscanner begin /d:sonar.host.url=$SONAR_URL /d:sonar.login=$SONAR_TOKEN /key:$SONAR_KEY /d:sonar.coverageReportPaths="results/coverage/SonarQube.xml" /d:sonar.exclusions="**/Migrations/*,Server/Views/**/*,**/wwwroot/**/*"
            - dotnet build $PROJECT_NAME
            - dotnet sonarscanner end /d:sonar.login=$SONAR_TOKEN
```
