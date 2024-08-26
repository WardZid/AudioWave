using AudioFileService.API.DTOs;
using AudioFileService.API.Services;
using AudioFileService.API.Services.IServices;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
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
        public async Task<IActionResult> GetChunk([FromQuery] FetchChunkDto fetchChunkDto)
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


                (Stream, string) chunkTuple = await _playbackService.FetchChunkAsync(fetchChunkDto, userId, bucketName);

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
    }
}
