using MetadataService.Core.DTOs;
using MetadataService.Service.IServices;
using MetadataService.Infrastructure.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using System.ComponentModel.DataAnnotations;

namespace MetadataService.API.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class AudioController(
        IAudioService audioService
        ) : ControllerBase
    {
        private readonly IAudioService _audioService = audioService;


        [HttpGet("{id}")]
        public async Task<ActionResult<Audio>> GetAudio([Required] int id)
        {
            var audio = await _audioService.GetAudioById(id);
            if (audio == null)
            {
                return NotFound();
            }
            return Ok(audio);
        }

        [HttpGet]
        public async Task<ActionResult<IEnumerable<Audio>>> GetAllAudios()
        {
            var audios = await _audioService.GetAllAudios();
            return Ok(audios);
        }

        [Authorize]
        [HttpPost]
        public async Task<ActionResult> AddAudio(AddAudioDto audioDto)
        {
            try
            {
                if (audioDto == null)
                {
                    return BadRequest();
                }

                var audioId = await _audioService.AddAudio(audioDto);

                if (audioId == 0)
                {
                    return StatusCode(500);
                }
                return CreatedAtAction(nameof(GetAudioById), new { id = audioId }, audioId);
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
                        details = "An unexpected error occurred while processing your request. Please try again later."
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

            var updatedAudio = await _audioService.UpdateAudio(audio);
            if (updatedAudio == null)
            {
                return NotFound();
            }

            return Ok(updatedAudio);
        }

        [Authorize]
        [HttpDelete("{id}")]
        public async Task<ActionResult> DeleteAudio(int id)
        {
            var success = await _audioService.DeleteAudio(id);
            if (success == false)
            {
                return NotFound();
            }
            return Ok("Audio deleted Successfully");
        }
    }
}
