FROM mcr.microsoft.com/dotnet/aspnet:5.0 AS base
# Setup NodeJs
RUN apt-get update
RUN apt-get -y install curl gnupg
RUN curl -sL https://deb.nodesource.com/setup_14.x | bash -
RUN apt-get install -y nodejs
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
WORKDIR "/src/."
RUN dotnet build "angular.csproj" -c Release -o /app

FROM build AS publish
RUN dotnet publish "angular.csproj" -c Release -o /app

FROM base AS final
WORKDIR /app/ClientApp
COPY . .
RUN npm install
RUN npm rebuild node-sass
RUN npm run build -- --prod

WORKDIR /app
COPY --from=build /app .
COPY --from=node_build /src/dist ./ClientApp/dist
ENTRYPOINT ["dotnet", "angular.dll"]