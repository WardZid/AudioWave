using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using UsersService.Infrastructure.Models;

namespace UsersService.Infrastructure.Repositories
{
    public interface ILikeRepository
    {
        Task AddLikeAsync(Like like);
        Task DeleteLikeAsync(int audioId);
        Task<List<Like>> GetLikesByUserIdAsync(int userId);
    }
}
