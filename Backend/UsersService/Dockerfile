# Stage 1: Restore dependencies and build the projects
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build-env
WORKDIR /app

# Copy the solution file
COPY UsersService.sln ./

# Copy all project files
COPY UsersService.API/UsersService.API.csproj UsersService.API/
COPY UsersService.Core/UsersService.Core.csproj UsersService.Core/
COPY UsersService.Infrastructure/UsersService.Infrastructure.csproj UsersService.Infrastructure/
COPY UsersService.Service/UsersService.Service.csproj UsersService.Service/

# Copy the external library
COPY libs/ /app/libs/

# Restore dependencies for all projects
RUN dotnet restore

# Copy the rest of the files
COPY . ./

# Build the projects
RUN dotnet build -c Release --no-restore

# Publish the API project
RUN dotnet publish UsersService.API/UsersService.API.csproj -c Release -o out --no-restore

# Stage 2: Build the runtime image
FROM mcr.microsoft.com/dotnet/aspnet:8.0
WORKDIR /app
COPY --from=build-env /app/out .

# Expose the port the app runs on
EXPOSE 8080
EXPOSE 8081

# Set the entry point for the container
ENTRYPOINT ["dotnet", "UsersService.API.dll"]
