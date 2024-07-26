using Amazon.S3.Model;
using Amazon.S3;
using AudioFileService.API.Services.IServices;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using AudioFileService.API.DTOs;
using Microsoft.AspNetCore.Authorization;
using System.Security.Claims;

namespace AudioFileService.API.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    [Authorize]
    public class UploadController(
        IUploadService uploadService
        ) : ControllerBase
    {
        private readonly IUploadService _uploadService = uploadService;


        [HttpPost("Chunk")]
        public async Task<IActionResult> UploadChunk(UploadChunkDto uploadChunkDto)
        {
            if (ModelState.IsValid == false) {
                return BadRequest();
            }
            try
            {
                var userIdClaim = User.FindFirst(ClaimTypes.NameIdentifier);
                if (userIdClaim == null)
                {
                    return Unauthorized("User ID not found in token.");
                }

                int userId = int.Parse(userIdClaim.Value);
                
                string chunkKey = await _uploadService.UploadChunkAsync(uploadChunkDto, userId);

                return Created(string.Empty,chunkKey);
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
        }
    }
}
