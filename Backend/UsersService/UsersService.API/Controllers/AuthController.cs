using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using UsersService.Core.DTOs;
using UsersService.Service;
using UsersService.Service.IService;

namespace UsersService.API.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class AuthController(
        IUserService userService,
        TokenService tokenService,
        AuthEncryptionService authEncryptionService
        ) : ControllerBase
    {
        private readonly IUserService _userService = userService;
        private readonly TokenService _tokenService = tokenService;
        private readonly AuthEncryptionService _authEncryptionService = authEncryptionService;


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

        [HttpPost("register-encrypted")]
        public async Task<IActionResult> RegisterEncrypted([FromBody] string userRegistrationDtoEncrypted)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            // decry[pt and deserialize
            UserRegistrationDto dto = _authEncryptionService.DecryptObject<UserRegistrationDto>(userRegistrationDtoEncrypted);

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
            var (privatekey, publickey) = (_authEncryptionService.PrivateKey, _authEncryptionService.PublicKey);

            var user = await _userService.AuthenticateUserAsync(dto.Email, dto.Password);
            if (user == null)
            {
                return Unauthorized("Invalid username or password");
            }

            // Authentication successful, generate and return JWT token
            var token = _tokenService.GenerateToken(user.Id.ToString(), user.Email, 30);
            return Ok(new { Token = token });
        }

        [HttpPost("login-encrypted")]
        public async Task<IActionResult> LoginEncrypted([FromBody] string userLoginDtoEncrypted)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            // decrypt into dto
            UserLoginDto dto = _authEncryptionService.DecryptObject<UserLoginDto>(userLoginDtoEncrypted);

            var user = await _userService.AuthenticateUserAsync(dto.Email, dto.Password);
            if (user == null)
            {
                return Unauthorized("Invalid username or password");
            }

            // Authentication successful, generate and return JWT token
            var token = _tokenService.GenerateToken(user.Id.ToString(), user.Email, 30);
            return Ok(new { Token = token });
        }

        [HttpGet("public-key")]
        public async Task<IActionResult> GetPublicEncryptionKey()
        {
            if (!ModelState.IsValid)
            { return BadRequest(ModelState); }

            string publicEncryptionKey = _authEncryptionService.PublicKey;

            if (string.IsNullOrEmpty(publicEncryptionKey))
            { return StatusCode(StatusCodes.Status503ServiceUnavailable) ; }

            return Ok(publicEncryptionKey);
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