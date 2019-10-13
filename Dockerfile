FROM mcr.microsoft.com/dotnet/core/sdk:3.0-alpine AS build

WORKDIR /app

COPY *.csproj ./
RUN dotnet restore

COPY . ./
WORKDIR /app

RUN dotnet publish -c Release -r linux-musl-x64 --self-contained=false -o test2

RUN dotnet test --no-build --no-restore -o test2

FROM mcr.microsoft.com/dotnet/core/aspnet:3.0-alpine AS runtime
WORKDIR /app
COPY --from=build /app/test2 ./
ENTRYPOINT ["dotnet", "deploy.dll"]