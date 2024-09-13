using MetadataService.Infrastructure.Data;
using MetadataService.Infrastructure.IRepositories;
using MetadataService.Infrastructure.Models;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MetadataService.Infrastructure.Repositories
{
    public class StatusRepository(
        MetadataDbContext context
        ) : IStatusRepository
    {
        private readonly MetadataDbContext _context = context;

        public Task<Status> AddAsync(Status entity)
        {
            throw new NotImplementedException();
        }

        public async Task<IEnumerable<Status>> GetAllAsync()
        {
            return await _context.Statuses.ToListAsync();
        }

        public async Task<Status?> GetByIdAsync(int id)
        {
            return await _context.Statuses.FindAsync(id);
        }

        public async Task<Status> GetStatusByTitleAsync(string title)
        {

            return await _context.Statuses
                                 .FirstOrDefaultAsync(status => status.Status1.ToUpper() == title.ToUpper());


        }

        public Task<Status> UpdateAsync(Status entity, int userId)
        {
            throw new NotImplementedException();
        }

        public Task<bool> DeleteAsync(int id, int userId)
        {
            throw new NotImplementedException();
        }
    }
}
