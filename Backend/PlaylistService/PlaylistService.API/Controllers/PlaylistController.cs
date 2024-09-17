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

        [HttpGet]
        public async Task<ActionResult<IEnumerable<Playlist>>> Get()
        {
            var playlists = await _playlistService.GetAllAsync();
            return Ok(playlists);
        }

        [HttpGet("{id}")]
        public async Task<ActionResult<Playlist>> GetById(string id)
        {
            var playlist = await _playlistService.GetByIdAsync(id);
            if (playlist == null)
            {
                return NotFound();
            }
            return Ok(playlist);
        }

        //[Authorize]
        [HttpPost]
        public async Task<ActionResult> Create(AddPlaylistDto addPlaylistDto)
        {
            if (ModelState.IsValid == false)
            {
                return BadRequest();
            }
            try
            {
                //var userIdClaim = User.FindFirst(ClaimTypes.NameIdentifier);
                //if (userIdClaim == null)
                //{
                //    return Unauthorized("User ID not found in token.");
                //}

                //int userId = int.Parse(userIdClaim.Value);

                int userId = 2;

                string resultId = await _playlistService.CreateAsync(addPlaylistDto, userId);
                return CreatedAtAction(nameof(Create), new { id = resultId });
            }
            catch (Exception ex)
            {
                return NotFound(ex.Message);
            }
        }

        [Authorize]
        [HttpPut("{id}")]
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
        [HttpDelete("{id}")]
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
    }
}
