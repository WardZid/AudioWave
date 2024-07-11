using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using UsersService.Infrastructure.Data;
using UsersService.Infrastructure.Models;

namespace UsersService.Infrastructure.Repositories
{
    public class LikeRepository(
        UsersDbContext context
        ) : ILikeRepository
    {
        private readonly UsersDbContext _context= context;

        public Task AddLikeAsync(Like like)
        {
            
            _context.Likes.AddAsync( like );
            _context.SaveChangesAsync();

            return Task.CompletedTask;
        }

        public Task DeleteLikeAsync(int audioId)
        {
            throw new NotImplementedException();
        }

        public Task<List<Like>> GetLikesByUserIdAsync(int userId)
        {
            throw new NotImplementedException();
        }
    }
}