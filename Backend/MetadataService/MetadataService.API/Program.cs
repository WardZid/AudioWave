using MetadataService.Infrastructure.IRepositories;
using MetadataService.Service.IServices;
using MetadataService.Infrastructure.Data;
using MetadataService.Infrastructure.Repositories;
using MetadataService.Service;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;
using System.Text;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.

builder.Services.AddControllers();
// Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

//Services
builder.Services.AddScoped<IAudioService, AudioService>();

//Repositories
builder.Services.AddScoped<IAudioRepository, AudioRepository>();
builder.Services.AddScoped<IStatusRepository, StatusRepository>();


// Access SQL password from environment variable
string METADATADB_CONN = Environment.GetEnvironmentVariable("METADATADB_CONN");
if (string.IsNullOrEmpty(METADATADB_CONN))
{
    throw new InvalidOperationException("METADATADB_CONN environment variable is not set.");
}
//set conn string in the configuration
builder.Configuration["ConnectionStrings:MetadataDBConnection"] = METADATADB_CONN;


// Add DB Context
builder.Services.AddDbContext<MetadataDbContext>(options =>
    options.UseSqlServer(METADATADB_CONN));


// GET JWT SECRET FROM ENV VARS
string JWT_SECRET = Environment.GetEnvironmentVariable("JWT_SECRET");

if (string.IsNullOrEmpty(JWT_SECRET))
{
    throw new InvalidOperationException("JWT_SECRET environment variable is not set.");
}

// Update the configuration with the secret value
builder.Configuration["JwtSettings:Secret"] = JWT_SECRET;

// Configure JWT Authentication
var jwtSettings = builder.Configuration.GetSection("JwtSettings");
var secretKey = Encoding.UTF8.GetBytes(jwtSettings["Secret"]);

builder.Services.AddAuthentication(options =>
{
    options.DefaultAuthenticateScheme = JwtBearerDefaults.AuthenticationScheme;
    options.DefaultChallengeScheme = JwtBearerDefaults.AuthenticationScheme;
})
.AddJwtBearer(options =>
{
    options.TokenValidationParameters = new TokenValidationParameters
    {
        ValidateIssuer = true,
        ValidateAudience = true,
        ValidateLifetime = true,
        ValidateIssuerSigningKey = true,
        ValidIssuer = jwtSettings["Issuer"],
        ValidAudience = jwtSettings["Audience"],
        IssuerSigningKey = new SymmetricSecurityKey(secretKey)
    };
});


var app = builder.Build();

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

//app.UseHttpsRedirection();

// UseAuthentication has to be before UseAuthorization. for whatever reason
app.UseAuthentication();
app.UseAuthorization();

app.MapControllers();

app.Run();
