#See https://aka.ms/customizecontainer to learn how to customize your debug container and how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/aspnet:8.0-alpine3.18 AS base
USER app
WORKDIR /app
EXPOSE 8080

FROM mcr.microsoft.com/dotnet/sdk:8.0-alpine3.18 AS build
ARG BUILD_CONFIGURATION=Release
WORKDIR /src
COPY ["BangchakAuthService.csproj", "."]
RUN dotnet restore "./BangchakAuthService.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "./BangchakAuthService.csproj" -c $BUILD_CONFIGURATION -o /app/build

FROM build AS publish
ARG BUILD_CONFIGURATION=Release
RUN dotnet publish "./BangchakAuthService.csproj" -c $BUILD_CONFIGURATION -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "BangchakAuthService.dll"]


#docker build -t bangchak-auth-service-api:latest .
#docker build -t Codingthaliand/bangchak-auth-service-api:1.0.0 .
#docker run -d -p 5002:8080 --name bangchak-auth-service-api-container bangchak-auth-service-api:latest
#git add .
