
using MetadataService.Infrastructure.IRepositories;
using MetadataService.Infrastructure.Models;
using MetadataService.Infrastructure.Data;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MetadataService.Infrastructure.Repositories
{
    public class AudioRepository(
        MetadataDbContext context
        ) : IAudioRepository
    {
        private readonly MetadataDbContext _context = context;

        public async Task<Audio> AddAsync(Audio entity)
        {
            await _context.Set<Audio>().AddAsync(entity);
            await _context.SaveChangesAsync();
            return entity;
        }

        public async Task<bool> DeleteAsync(int id, int userId)
        {
            var entity = await GetByIdAsync(id);
            if (entity == null)
            {
                return false;
            }

            if (entity.UploaderId != userId)
            {
                throw new UnauthorizedAccessException("You are not authorized to update this audio.");
            }

            _context.Set<Audio>().Remove(entity);
            await _context.SaveChangesAsync();
            return true;
        }

        public async Task<IEnumerable<Audio>> GetAllAsync()
        {
            return await _context.Set<Audio>().ToListAsync();
        }

        public async Task<Audio?> GetByIdAsync(int id)
        {
            return await _context.Set<Audio>().FindAsync(id);
        }

        public async Task<Audio> UpdateAsync(Audio entity, int userId)
        {
            if (entity.UploaderId != userId)
            {
                throw new UnauthorizedAccessException("You are not authorized to update this audio.");
            }

            _context.Set<Audio>().Update(entity);
            await _context.SaveChangesAsync();
            return entity;
        }

        public async Task AddListenAsync(int audioId)
        {
            Audio? audio = await _context.Audios.FindAsync(audioId);

            if (audio == null)
            {
                throw new KeyNotFoundException("Audio not found.");
            }

            audio.Listens += 1;

            await _context.SaveChangesAsync();
        }

    }
}
