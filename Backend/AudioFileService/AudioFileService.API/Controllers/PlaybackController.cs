using AudioFileService.API.DTOs;
using AudioFileService.API.Services;
using AudioFileService.API.Services.IServices;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using System.IO;
using System.Net.Mime;
using System.Security.Claims;

namespace AudioFileService.API.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class PlaybackController(
        IPlaybackService playbackService
        ) : ControllerBase
    {
        private readonly IPlaybackService _playbackService = playbackService;
        private readonly string bucketName = "audiowave-bucket";

        [HttpGet("Chunk")]
        public async Task<IActionResult> GetChunk([FromQuery] GetChunkDto getChunkDto)
        {
            if (ModelState.IsValid == false)
            {
                return BadRequest();
            }
            try
            {
                var userIdClaim = User.FindFirst(ClaimTypes.NameIdentifier);
                int userId = -1;
                if (userIdClaim is not null)
                {
                    userId = int.Parse(userIdClaim.Value);
                }


                (Stream, string) chunkTuple = await _playbackService.GetChunkAsync(getChunkDto, userId, bucketName);

                return File(chunkTuple.Item1, chunkTuple.Item2);
            }
            catch (Exception ex)
            {
                switch (ex.Message)
                {
                    case "bucket":
                        return StatusCode(StatusCodes.Status500InternalServerError);
                    case "The specified key does not exist.":
                        return NotFound(ex.Message);
                    default:
                        return BadRequest(ex.Message);
                }
            }
        }

        [HttpGet("CombinedChunks")]
        public async Task<IActionResult> GetCombinedChunks([FromQuery] GetChunksDto getChunksDto)
        {
            if (ModelState.IsValid == false)
            {
                return BadRequest();
            }
            try
            {
                var userIdClaim = User.FindFirst(ClaimTypes.NameIdentifier);
                int userId = -1;
                if (userIdClaim is not null)
                {
                    userId = int.Parse(userIdClaim.Value);
                }


                var (stream, contentType) = await _playbackService.GetChunksAsync(getChunksDto, userId, bucketName);

                return File(stream, contentType);
            }
            catch (Exception ex)
            {
                switch (ex.Message)
                {
                    case "bucket":
                        return StatusCode(StatusCodes.Status500InternalServerError);
                    case "The specified key does not exist.":
                        return NotFound(ex.Message);
                    default:
                        return BadRequest(ex.Message);
                }
            }
        }
    }
}
