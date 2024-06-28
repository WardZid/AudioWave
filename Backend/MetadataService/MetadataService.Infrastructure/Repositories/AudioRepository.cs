using MetadataService.Core.Enitities;
using MetadataService.Core.Interfaces;
using MetadataService.Infrastructure.Data;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MetadataService.Infrastructure.Repositories
{
    internal class AudioRepository : IAudioRepository
    {
        private readonly MetadataDbContext _context;

        public AudioRepository(MetadataDbContext context)
        {
            _context = context;
        }

        public async Task<AudioEntity?> GetAudioByIdAsync(int id)
        {
            //Models.Audio aud = await _context.Audios.FindAsync(id);

            throw new NotImplementedException();
        }

        public async Task AddAudioAsync(AudioEntity audioEntity)
        {
            throw new NotImplementedException();
        }

        public async Task DeleteAudioAsync(int id)
        {
            throw new NotImplementedException();
        }

        public async Task UpdateAudioAsync(AudioEntity audioEntity)
        {
            throw new NotImplementedException();
        }
    }
}
