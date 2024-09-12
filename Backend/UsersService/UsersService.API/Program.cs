using AudioWaveBroker;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;
using System.Text;
using UsersService.Infrastructure.Data;
using UsersService.Infrastructure.Repositories;
using UsersService.Infrastructure.Repositories.IRepositories;
using UsersService.Service;
using UsersService.Service.IService;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.

builder.Services.AddControllers();
// Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

//Add Services
builder.Services.AddScoped<IUserService, UserService>();
builder.Services.AddScoped<ILikeService, LikeService>();
builder.Services.AddScoped<IFollowService, FollowService>();

builder.Services.AddHostedService<MessageConsumerService>(); //for rabbitmq
builder.Services.AddTransient<MessageProducerService>();    //for rabbitmq
builder.Services.AddSingleton<IMessageHandler, UsersMessageHandler>(); //for rabbitmq

//Add Repositories
builder.Services.AddScoped<IUserRepository, UserRepository>();
builder.Services.AddScoped<ILikeRepository, LikeRepository>();
builder.Services.AddScoped<IFollowRepository, FollowRepository>();




//######################################################################## UsersDB start
// Access SQL password from environment variable
string USERS_DB_CONNECTION_STRING = Environment.GetEnvironmentVariable("USERSDB_CONN");
if (string.IsNullOrEmpty(USERS_DB_CONNECTION_STRING))
{
    throw new InvalidOperationException("USERS_DB_CONNECTION_STRING environment variable is not set.");
}
//set conn string in the configuration
builder.Configuration["ConnectionStrings:UsersDBConnection"] = USERS_DB_CONNECTION_STRING;

// Add DB Context
builder.Services.AddDbContext<UsersDbContext>(options =>
    options.UseSqlServer(USERS_DB_CONNECTION_STRING));
//######################################################################## UsersDB end




//######################################################################## MongoDB start
string MONGO_CRED_SECRET_CONN = Environment.GetEnvironmentVariable("MONGO_CRED_SECRET_CONN");
if (string.IsNullOrEmpty(MONGO_CRED_SECRET_CONN))
{
    throw new InvalidOperationException("MONGO_CRED_SECRET_CONN environment variable is not set.");
}
//set conn string in the configuration
builder.Configuration["ConnectionStrings:MONGO_CRED_SECRET_CONN"] = MONGO_CRED_SECRET_CONN;

builder.Services.AddSingleton<AuthEncryptionService>();
//######################################################################## MongoDB end





//######################################################################## JWT start
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

//Add special token service
builder.Services.AddSingleton<TokenService>();
//######################################################################## JWT end


var app = builder.Build();

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}
else
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
