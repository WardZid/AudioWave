using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using UsersService.Core.DTOs;
using UsersService.Service;

namespace UsersService.API.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class AuthController : ControllerBase
    {
        private readonly IUserService _userService;

        public AuthController(IUserService userService)
        {
            _userService = userService;
        }

        [HttpPost("register")]
        public async Task<IActionResult> Register(UserRegistrationDto dto)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            var result = await _userService.RegisterUserAsync(dto);

            if (!result)
            {
                return Conflict("Username Or Email already exists");
            }

            return Ok("Registration successful");
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