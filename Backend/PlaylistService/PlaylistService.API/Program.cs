using AudioWaveBroker;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.IdentityModel.Tokens;
using PlaylistService.API.Repositories;
using PlaylistService.API.Services;
using PlaylistService.API.Settings;
using System.Text;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.

builder.Services.AddControllers();

// Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

// Repositories
builder.Services.AddScoped<IPlaylistRepository, PlaylistRepository>();

//Services
builder.Services.AddScoped<IPlaylistService, PlaylistService.API.Services.PlaylistService>();
builder.Services.AddSingleton<MongoDbService>();



builder.Services.AddTransient<MessageProducerService>();    //for rabbitmq
if (builder.Environment.IsDevelopment() == false)
{
    builder.Services.AddHostedService<MessageConsumerService>(); //for rabbitmq
    builder.Services.AddSingleton<IMessageHandler, PlaylistMessageHandler>();

}

//**************************************************************    MONGODB start

var PLAYLIST_CONN = Environment.GetEnvironmentVariable("PLAYLIST_CONN");

if (string.IsNullOrEmpty(PLAYLIST_CONN))
{
    throw new InvalidOperationException("PLAYLIST_CONN environment variable is not set.");
}
//set conn string in the configuration
builder.Configuration["ConnectionStrings:PLAYLIST_CONN"] = PLAYLIST_CONN;


builder.Services.AddSingleton<MongoDbService>();
//**************************************************************    MONGODB end


//**************************************************************    JWT start

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


//**************************************************************    JWT end

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
