using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using UsersService.Core.DTOs;
using UsersService.Service;

namespace UsersService.API.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class AuthController(
        IUserService userService,
        TokenService tokenService
        ) : ControllerBase
    {
        private readonly IUserService _userService = userService;
        private readonly TokenService _tokenService = tokenService;


        [HttpPost("register")]
        public async Task<IActionResult> Register(UserRegistrationDto dto)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            var result = await _userService.RegisterUserAsync(dto.Email, dto.Username, dto.Password, dto.FirstName, dto.LastName);

            if (!result)
            {
                return Conflict("Username Or Email already exists");
            }

            return Ok("Registration successful");
        }

        [HttpPost("login")]
        public async Task<IActionResult> Login(UserLoginDto dto)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            var user = await _userService.AuthenticateUserAsync(dto.Email, dto.Password);
            if (user == null)
            {
                return Unauthorized("Invalid username or password");
            }

            // Authentication successful, generate and return JWT token
            var token = _tokenService.GenerateToken(user.Id.ToString(), user.Email, 30);
            return Ok(new { Token = token });
        }

        [HttpPost("check-username")]
        public async Task<IActionResult> CheckUsername([FromBody] string username)
        {
            if (string.IsNullOrWhiteSpace(username))
            {
                return BadRequest("Username is required");
            }

            var exists = await _userService.UsernameExists(username);
            return Ok(exists);
        }

        [HttpPost("check-email")]
        public async Task<IActionResult> CheckEmail([FromBody] string email)
        {
            if (string.IsNullOrWhiteSpace(email))
            {
                return BadRequest("Email is required");
            }

            var exists = await _userService.EmailExists(email);
            return Ok(exists);
        }
    }
}