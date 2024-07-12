using Azure.Core;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using System.ComponentModel.DataAnnotations;
using System.Security.Claims;
using UsersService.Infrastructure.Models;
using UsersService.Service;

namespace UsersService.API.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    [Authorize]
    public class FollowController(
        IFollowService followService
        ) : ControllerBase
    {
        private readonly IFollowService _followService = followService;


        [HttpPost("AddFollow")]
        public async Task<IActionResult> AddFollow([FromBody][Required] int followeeId)
        {
            var userIdClaim = User.FindFirst(ClaimTypes.NameIdentifier);
            if (userIdClaim == null)
            {
                return Unauthorized("User ID not found in token.");
            }

            int userId = int.Parse(userIdClaim.Value);

            try
            {
                var result = await _followService.AddFollow(userId, followeeId);

                if (result)
                {
                    return NoContent();
                }
                else
                {
                    return BadRequest("Unable to follow user.");
                }
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }


        }

        [HttpDelete("RemoveFollow")]
        public async Task<IActionResult> RemoveFollow([FromBody][Required] int followeeId)
        {
            var userIdClaim = User.FindFirst(ClaimTypes.NameIdentifier);
            if (userIdClaim == null)
            {
                return Unauthorized("User ID not found in token.");
            }

            int userId = int.Parse(userIdClaim.Value);
            try
            {

                var result = await _followService.RemoveFollow(userId, followeeId);

                if (result)
                {
                    return NoContent();
                }
                else
                {
                    return BadRequest("Unable to unfollow user.");
                }

            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
        }

        [HttpDelete("RemoveFollower")]
        public async Task<IActionResult> RemoveFollower([FromBody][Required] int followerId)
        {
            var userIdClaim = User.FindFirst(ClaimTypes.NameIdentifier);
            if (userIdClaim == null)
            {
                return Unauthorized("User ID not found in token.");
            }

            int userId = int.Parse(userIdClaim.Value);

            try
            {

                var result = await _followService.RemoveFollow(followerId, userId);

                if (result)
                {
                    return NoContent();
                }
                else
                {
                    return BadRequest("Unable to remove follower.");
                }

            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
        }


        [HttpGet("GetFollowers")]
        public async Task<ActionResult<IEnumerable<User>>> GetFollowers()
        {
            var userIdClaim = User.FindFirst(ClaimTypes.NameIdentifier);
            if (userIdClaim == null)
            {
                return Unauthorized("User ID not found in token.");
            }

            int userId = int.Parse(userIdClaim.Value);

            IEnumerable<User> followers = await _followService.GetFollowers(userId);

            return Ok(followers);
        }

        [HttpGet("GetFollowing")]
        public async Task<ActionResult<IEnumerable<User>>> GetFollowing()
        {
            var userIdClaim = User.FindFirst(ClaimTypes.NameIdentifier);
            if (userIdClaim == null)
            {
                return Unauthorized("User ID not found in token.");
            }

            int userId = int.Parse(userIdClaim.Value);

            IEnumerable<User> following = await _followService.GetFollowing(userId);

            return Ok(following);
        }
    }
}
