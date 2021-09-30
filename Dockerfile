FROM mcr.microsoft.com/dotnet/aspnet:5.0 AS base
# Setup NodeJs
RUN apt-get update
RUN apt-get -y install curl gnupg
RUN curl -sL https://deb.nodesource.com/setup_14.18.0 | bash -
RUN apt-get install -y nodejs
RUN npm install @angular/cli -g
# End setup

FROM mcr.microsoft.com/dotnet/sdk:5.0 AS build
WORKDIR /src
COPY ["angular.csproj", "./"]
RUN dotnet restore "angular.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "angular.csproj" -c Release -o /app
RUN dotnet publish "angular.csproj" -c Release -o /app

FROM node:14.18.0 AS node-build
WORKDIR /src
COPY ./ClientApp .
RUN npm install
RUN npm rebuild node-sass
RUN npm run build -- --prod

FROM base
WORKDIR /app
EXPOSE 80
EXPOSE 443
COPY --from=build /app .
COPY --from=node_build /src/dist ./ClientApp/dist
ENTRYPOINT ["dotnet", "angular.dll"]