# dotnetcore-sdk-sonar-scanner

Dockerimage with .net core sdk and sonar scanner

# Usage

## Bitbucket Pipeline
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
