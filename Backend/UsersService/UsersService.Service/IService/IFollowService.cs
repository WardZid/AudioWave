using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using UsersService.Infrastructure.Models;

namespace UsersService.Service.IService
{
    public interface IFollowService
    {
        Task<bool> AddFollow(int followerId, int followeeId);
        Task<bool> RemoveFollow(int followerId, int followeeId);
        Task<IEnumerable<User>> GetFollowers(int followeeId);
        Task<IEnumerable<User>> GetFollowing(int followerId);
    }
}
