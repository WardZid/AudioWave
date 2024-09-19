using MetadataService.Core.DTOs;
using MetadataService.Service.IServices;
using MetadataService.Infrastructure.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using System.ComponentModel.DataAnnotations;
using System.Security.Claims;

namespace MetadataService.API.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class AudioController(
        IAudioService audioService,
        IStatusService statusService,
        IVisibilityService visibilityService
        ) : ControllerBase
    {
        private readonly IAudioService _audioService = audioService;
        private readonly IStatusService _statusService = statusService;
        private readonly IVisibilityService _visibilityService = visibilityService;

        [HttpGet("{id}")]
        public async Task<ActionResult<Audio>> GetAudio([Required] int id)
        {
            try
            {
                int userId = -1;

                var userIdClaim = User.FindFirst(ClaimTypes.NameIdentifier);
                if (userIdClaim != null)
                {
                    userId = int.Parse(userIdClaim.Value);
                }

                var audio = await _audioService.GetAudioById(id, userId);

                return Ok(audio);
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
        }

        [HttpGet("GetAudioForListen/{id}")]
        public async Task<ActionResult<Audio>> GetAudioForListen([Required] int id)
        {
            try
            {
                int userId = -1;

                var userIdClaim = User.FindFirst(ClaimTypes.NameIdentifier);
                if (userIdClaim != null)
                {
                    userId = int.Parse(userIdClaim.Value);
                }

                var audio = await _audioService.GetAudioForListen(id, userId);

                return Ok(audio);
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
        }

        [HttpGet]
        public async Task<ActionResult<IEnumerable<Audio>>> GetAllAudios()
        {
            try
            {
                var audios = await _audioService.GetAllAudios();
                return Ok(audios);

            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
        }

        [HttpGet("GetAudiosByUser")]
        public async Task<ActionResult<IEnumerable<Audio>>> GetAudiosByUser([FromQuery] int uploaderId)
        {
            try
            {
                int userId = -1;
                var userIdClaim = User.FindFirst(ClaimTypes.NameIdentifier);
                if (userIdClaim != null)
                {
                    userId = int.Parse(userIdClaim.Value);
                }


                var audios = await _audioService.GetAllAudiosByUserID(uploaderId, userId);
                return Ok(audios);

            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
        }

        [Authorize]
        [HttpPost]
        public async Task<IActionResult> AddAudio(AddAudioDto audioDto)
        {

            if (audioDto == null)
            {
                return BadRequest("dto null");
            }

            var userIdClaim = User.FindFirst(ClaimTypes.NameIdentifier);
            if (userIdClaim == null)
            {
                return Unauthorized("User ID not found in token.");
            }

            int userId = int.Parse(userIdClaim.Value);

            try
            {

                var audioId = await _audioService.AddAudio(audioDto, userId);

                if (audioId == 0)
                {
                    return StatusCode(500, "Error audio 0");
                }
                return CreatedAtAction(nameof(GetAudio), new { id = audioId }, audioId);
            }
            catch (Exception ex)
            {
                Console.WriteLine($"An error occurred: {ex.Message}");

                return StatusCode(500, new
                {
                    error = new
                    {
                        code = 500,
                        message = "Internal Server Error",
                        details = "An unexpected error occurred while processing your request. Please try again later. Error: " + ex.Message
                    }
                });
            }
        }

        [Authorize]
        [HttpPut("{id}")]
        public async Task<ActionResult<Audio>> UpdateAudio(int id, [FromBody] Audio audio)
        {
            if (audio == null || id != audio.Id)
            {
                return BadRequest();
            }

            var userIdClaim = User.FindFirst(ClaimTypes.NameIdentifier);
            if (userIdClaim == null)
            {
                return Unauthorized("User ID not found in token.");
            }

            int userId = int.Parse(userIdClaim.Value);

            var updatedAudio = await _audioService.UpdateAudio(audio, userId);
            if (updatedAudio == null)
            {
                return NotFound();
            }

            return Ok(updatedAudio);
        }

        [Authorize]
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteAudio(int id)
        {
            var userIdClaim = User.FindFirst(ClaimTypes.NameIdentifier);
            if (userIdClaim == null)
            {
                return Unauthorized("User ID not found in token.");
            }

            int userId = int.Parse(userIdClaim.Value);

            var success = await _audioService.DeleteAudio(id, userId);
            if (success == false)
            {
                return NotFound();
            }
            return Ok("Audio deleted Successfully");
        }

        [HttpGet("GetStatuses")]
        public async Task<IActionResult> GetStatuses()
        {
            try
            {
                var statuses = await _statusService.GetStatusesAsync();

                return Ok(statuses);
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
        }

        [HttpGet("GetVisibilities")]
        public async Task<IActionResult> GetVisibilities()
        {
            try
            {
                var statuses = await _visibilityService.GetVisibilitiesAsync();

                return Ok(statuses);
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
        }
    }
}
