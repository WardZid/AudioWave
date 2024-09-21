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
    public class ListenRepository(
        MetadataDbContext context
        ) : IListenRepository
    {
        private readonly MetadataDbContext _context = context;

        public async Task<Listen> AddAsync(Listen entity)
        {
            await _context.Set<Listen>().AddAsync(entity);
            await _context.SaveChangesAsync();
            return entity;
        }

        public async Task<Listen> AddAsync(int audioId, int userId)
        {
            try
            {

                Listen newListen = new Listen();
                newListen.AudioId = audioId;
                newListen.UserId = userId;

                await _context.Set<Listen>().AddAsync(newListen);
                await _context.SaveChangesAsync();
                return newListen;
            }
            catch (Exception ex)
            {
                throw new Exception("Couldnt add listen to listen history" + ex.Message, ex);
            }
        }

        public async Task<bool> DeleteAsync(int id, int userId)
        {
            throw new NotImplementedException();
        }

        public async Task<IEnumerable<Listen>> GetAllAsync()
        {
            return await _context.Set<Listen>().ToListAsync();
        }

        public async Task<Listen?> GetByIdAsync(int id)
        {
            throw new NotImplementedException();
        }

        public async Task<Listen> UpdateAsync(Listen entity, int userId)
        {
            throw new NotImplementedException();
        }
    }
}
