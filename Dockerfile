# escape=`
#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/aspnet:5.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

ARG skip_client_build=false
WORKDIR /app
COPY /ClientApp .
RUN if [ "$skip_client_build" == true ]; `
then `
echo "Skipping npm install"; `
mkdir -p dist; `
else `
npm install; `
npm run build; `
fi

FROM mcr.microsoft.com/dotnet/sdk:5.0 AS build
WORKDIR /src
COPY ["angular.csproj", "./"]
RUN dotnet restore "angular.csproj"
COPY . .
WORKDIR "/src/"
RUN dotnet build "angular.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "angular.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
COPY --from=client /app/dist ClientApp/dist
ENTRYPOINT ["dotnet", "angular.dll"]