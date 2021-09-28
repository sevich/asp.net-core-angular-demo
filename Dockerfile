FROM mcr.microsoft.com/dotnet/aspnet:5.0 AS build
WORKDIR /app

COPY *.sln .
COPY app/.*csproj ./app/
RUN dotnet restore

COPY app/. ./app/
WORKDIR /source/app
RUN dotnet publish -c release -o /app --no-restore

FROM mcr.microsoft.com/dotnet/aspnet:5.0
WORKDIR /app
COPY --from=build /app ./
ENTRYPOINT ["dotnet", "aspnetapp.dll"]