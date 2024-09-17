using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using PlaylistService.API.DTOs;
using PlaylistService.API.Models;
using PlaylistService.API.Services;
using System.Security.Claims;

namespace PlaylistService.API.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class PlaylistController : ControllerBase
    {
        private readonly IPlaylistService _playlistService;

        public PlaylistController(IPlaylistService playlistService)
        {
            _playlistService = playlistService;
        }

        [HttpGet("GetAll")]
        public async Task<ActionResult<IEnumerable<Playlist>>> GetAll()
        {
            var playlists = await _playlistService.GetAllAsync();
            return Ok(playlists);
        }


        [HttpGet("GetById")]
        public async Task<ActionResult<Playlist>> GetById(string id)
        {

            try
            {
                int userId = -1;
                var userIdClaim = User.FindFirst(ClaimTypes.NameIdentifier);
                if (userIdClaim != null)
                {
                    userId = int.Parse(userIdClaim.Value);
                }

                var playlist = await _playlistService.GetByIdAsync(id, userId);
                if (playlist == null)
                {
                    return NotFound();
                }
                return Ok(playlist);

            }
            catch (KeyNotFoundException ex)
            {
                return NotFound(ex.Message);
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
        }

        [HttpGet("GetByUploader")]
        public async Task<ActionResult<Playlist>> GetByUploaderId(int UploaderId)
        {
            try
            {
                int userId = -1;
                var userIdClaim = User.FindFirst(ClaimTypes.NameIdentifier);
                if (userIdClaim != null)
                {
                    userId = int.Parse(userIdClaim.Value);
                }


                var playlist = await _playlistService.GetByUploaderIdAsync(UploaderId, userId);
                if (playlist == null)
                {
                    return NotFound();
                }
                return Ok(playlist);

            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
        }


        [Authorize]
        [HttpPost("AddPlaylist")]
        public async Task<ActionResult> Create(AddPlaylistDto addPlaylistDto)
        {
            if (ModelState.IsValid == false)
            {
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

                string resultId = await _playlistService.CreateAsync(addPlaylistDto, userId);
                return CreatedAtAction(nameof(Create), new { id = resultId });
            }
            catch (Exception ex)
            {
                return NotFound(ex.Message);
            }
        }

        [Authorize]
        [HttpPut("UpdatePlaylist")]
        public async Task<IActionResult> Update([FromBody] UpdatePlaylistDto updatePlaylistDto)
        {
            if (ModelState.IsValid == false)
            {
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

                await _playlistService.UpdateAsync(updatePlaylistDto, userId);
                return NoContent();
            }
            catch (Exception ex)
            {
                return NotFound(ex.Message);
            }
        }

        [Authorize]
        [HttpDelete("DeletePlaylist")]
        public async Task<IActionResult> Delete([FromBody] DeletePlaylistDto deletePlaylistDto)
        {
            if (ModelState.IsValid == false)
            {
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

                await _playlistService.DeleteAsync(deletePlaylistDto, userId);
                return NoContent();
            }
            catch (Exception ex)
            {
                return NotFound(ex.Message);
            }
        }

        [Authorize]
        [HttpPost("AddAudio")]
        public async Task<IActionResult> AddAudio([FromBody] AddAudioDto addAudioDto)
        {
            if (ModelState.IsValid == false)
            {
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

                await _playlistService.AddAudioAsync(addAudioDto, userId);
                return NoContent();
            }
            catch (Exception ex)
            {
                return NotFound(ex.Message);
            }
        }

        [Authorize]
        [HttpPost("RemoveAudio")]
        public async Task<IActionResult> RemoveAudio([FromBody] RemoveAudioDto removeAudioDto)
        {
            if (ModelState.IsValid == false)
            {
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

                await _playlistService.RemoveAudioAsync(removeAudioDto, userId);
                return NoContent();
            }
            catch (Exception ex)
            {
                return NotFound(ex.Message);
            }
        }

        [HttpPost("AccessLevels")]
        public async Task<IActionResult> GetAccessLevels()
        {
            try
            {
                var accessLevels = await _playlistService.GetAccessLevels();
                return Ok(accessLevels);
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
        }
    }
}
