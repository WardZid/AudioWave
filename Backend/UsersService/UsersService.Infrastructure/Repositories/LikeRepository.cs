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

        public async Task AddLikeAsync(Like like)
        {
            
            await _context.Likes.AddAsync( like );
            await _context.SaveChangesAsync();

        }

        public async Task DeleteLikeAsync(Like like)
        {
            _context.Likes.Remove(like);
            await _context.SaveChangesAsync();
        }

        public async Task<List<Like>> GetLikesByUserIdAsync(int userId)
        {
            return await _context.Likes
                .Where(like => like.UserId == userId)
                .ToListAsync();
        }
    }
}