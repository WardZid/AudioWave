using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using UsersService.Infrastructure.Models;
using UsersService.Infrastructure.Repositories;
using UsersService.Service.IService;

namespace UsersService.Service
{
    public class FollowService(
        IFollowRepository followRepository
        ) : IFollowService
    {
        private readonly IFollowRepository _followRepository = followRepository;


        public async Task<bool> AddFollow(int followerId, int followeeId)
        {
            if (followerId == followeeId)
            {
                throw new ArgumentException("cannot follow self");
            }
            Follow follow = new()
            {
                FollowerId = followerId,
                FollowedId = followeeId,
                FollowedAt = DateTime.Now,
            };
            return await _followRepository.AddFollowAsync(follow);
        }

        public async Task<bool> RemoveFollow(int followerId, int followeeId)
        {

            if (followerId == followeeId)
            {
                throw new ArgumentException("cannot unfollow self");
            }

            Follow follow = new()
            {
                FollowerId = followerId,
                FollowedId = followeeId,
                FollowedAt = DateTime.Now,
            };
            return await _followRepository.RemoveFollowAsync(follow);
        }

        public async Task<IEnumerable<User>> GetFollowers(int followeeId)
        {
            return await _followRepository.GetAllFollowersAsync(followeeId);
        }

        public async Task<IEnumerable<User>> GetFollowing(int followerId)
        {
            return await _followRepository.GetAllFollowingAsync(followerId);
        }

    }
}
