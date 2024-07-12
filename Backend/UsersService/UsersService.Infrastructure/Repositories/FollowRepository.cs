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
    public class FollowRepository(
        UsersDbContext context
        ) : IFollowRepository
    {

        private readonly UsersDbContext _context = context;

        public async Task AddFollowAsync(Follow follow)
        {
            await _context.Follows.AddAsync( follow );
            await _context.SaveChangesAsync();
        }

        public async Task RemoveFollowAsync(Follow follow)
        {
            _context.Follows.Remove(follow);
            await _context.SaveChangesAsync();
        }

        public async Task<IEnumerable<User>> GetAllFollowersAsync(int userId)
        {
            return await _context.Follows
               .Where(f => f.FollowedId == userId)
               .Select(f => f.Follower)
               .ToListAsync();
        }

        public async Task<IEnumerable<User>> GetAllFollowingAsync(int userId)
        {
            return await _context.Follows
                .Where(f => f.FollowerId == userId)
                .Select(f => f.Followed)
                .ToListAsync();
        }

    }
}
