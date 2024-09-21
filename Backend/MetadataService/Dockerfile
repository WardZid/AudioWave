# Stage 1: Restore dependencies and build the projects
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build-env
WORKDIR /app

# Copy the solution file
COPY MetadataService.sln ./

# Copy all project files
COPY MetadataService.API/MetadataService.API.csproj MetadataService.API/
COPY MetadataService.Core/MetadataService.Core.csproj MetadataService.Core/
COPY MetadataService.Infrastructure/MetadataService.Infrastructure.csproj MetadataService.Infrastructure/
COPY MetadataService.Service/MetadataService.Service.csproj MetadataService.Service/

# Copy the external library
COPY libs/ /app/libs/

# Restore dependencies for all projects
RUN dotnet restore

# Copy the rest of the files
COPY . ./

# Build the projects
RUN dotnet build -c Release --no-restore

# Publish the API project
RUN dotnet publish MetadataService.API/MetadataService.API.csproj -c Release -o out --no-restore

# Stage 2: Build the runtime image
FROM mcr.microsoft.com/dotnet/aspnet:8.0
WORKDIR /app
COPY --from=build-env /app/out .

# Expose the port the app runs on
EXPOSE 8080
EXPOSE 8081

# Set the entry point for the container
ENTRYPOINT ["dotnet", "MetadataService.API.dll"]
