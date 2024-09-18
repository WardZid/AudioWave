using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using System.ComponentModel.DataAnnotations;
using System.Security.Claims;
using UsersService.Infrastructure.Models;
using UsersService.Service.IService;

namespace UsersService.API.Controllers;

[Route("api/[controller]")]
[ApiController]
[Authorize]
public class LikesController(
    ILikeService likeService
    ) : ControllerBase
{
    private readonly ILikeService _likeService = likeService;

    [Authorize]
    [HttpPost("AddLike")]
    public async Task<IActionResult> AddLike([FromHeader][Required] int audioId)
    {
        if (ModelState.IsValid == false)
        {
            return BadRequest(ModelState);
        }
        try
        {
            var userIdClaim = User.FindFirst(ClaimTypes.NameIdentifier);
            if (userIdClaim == null)
            {
                return Unauthorized("User ID not found in token.");
            }

            int userId = int.Parse(userIdClaim.Value);


            if (await _likeService.AddLike(userId, audioId))
                return Ok();
        }
        catch (Exception ex)
        {
            return BadRequest(ex.Message);
        }
        return BadRequest();
    }

    [Authorize]
    [HttpDelete("RemoveLike")]
    public async Task<IActionResult> RemoveLike([FromHeader][Required] int audioId)
    {
        if (ModelState.IsValid == false)
        {
            return BadRequest(ModelState);
        }
        try
        {
            var userIdClaim = User.FindFirst(ClaimTypes.NameIdentifier);
            if (userIdClaim == null)
            {
                return Unauthorized("User ID not found in token.");
            }

            int userId = int.Parse(userIdClaim.Value);


            if (await _likeService.RemoveLike(userId, audioId))
                return Ok();

        }
        catch (Exception ex)
        {
            return BadRequest(ex.Message);
        }
        return BadRequest();
    }

    [HttpGet("GetAll")]
    public async Task<ActionResult<List<Like>>> GetAll()
    {

        if (ModelState.IsValid == false)
        {
            return BadRequest(ModelState);
        }
        try
        {
            var userIdClaim = User.FindFirst(ClaimTypes.NameIdentifier);
            if (userIdClaim == null)
            {
                return Unauthorized("User ID not found in token.");
            }

            int userId = int.Parse(userIdClaim.Value);


            List<Like> likes = await _likeService.GetAllLikes(userId);

            return Ok(likes);
        }
        catch (Exception ex)
        {
            return BadRequest(ex.Message);
        }

    }
}