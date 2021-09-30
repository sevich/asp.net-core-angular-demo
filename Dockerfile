FROM mcr.microsoft.com/dotnet/aspnet:5.0 AS base
# Setup NodeJs
RUN apt-get update && \
    apt-get install -y wget && \
    apt-get install -y gnupg2 && \
    wget -qO- https://deb.nodesource.com/setup_10.x | bash - && \
    apt-get install -y build-essential nodejs
RUN npm install @angular/cli -g
# End setup

WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:5.0 AS build
WORKDIR /src
COPY ["angular.csproj", "./"]
RUN dotnet restore "angular.csproj"
COPY . .
WORKDIR "/"
RUN dotnet build "angular.csproj" -c Release -o /app

FROM build AS publish
RUN dotnet publish "angular.csproj" -c Release -o /app

FROM base AS final
WORKDIR /
COPY --from=publish / .
WORKDIR /ClientApp
RUN npm install
RUN npm rebuild node-sass
WORKDIR /
ENTRYPOINT ["dotnet", "angular.dll"]