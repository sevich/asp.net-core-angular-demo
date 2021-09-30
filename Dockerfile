FROM mcr.microsoft.com/dotnet/sdk:5.0 AS build
WORKDIR /src
COPY ["angular.csproj", "./"]
RUN dotnet restore "angular.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "angular.csproj" -c Release -o /app
RUN dotnet publish "angular.csproj" -c Release -o /app

FROM node:14 AS node-build
WORKDIR /src/ClientApp
COPY . .
RUN npm install
RUN npm rebuild node-sass
RUN npm run build -- --prod

FROM mcr.microsoft.com/dotnet/aspnet:5.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443
COPY --from=build /app .
COPY --from=node_build /src/dist ./ClientApp/dist
ENTRYPOINT ["dotnet", "angular.dll"]