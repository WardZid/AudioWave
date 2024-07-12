using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using UsersService.Infrastructure.Models;

namespace UsersService.Infrastructure.Repositories
{
    public interface IFollowRepository
    {
        Task<bool> AddFollowAsync(Follow follow);
        Task<bool> RemoveFollowAsync(Follow follow);
        Task<IEnumerable<User>> GetAllFollowersAsync(int userId);
        Task<IEnumerable<User>> GetAllFollowingAsync(int userId);
    }
}
