using MetadataService.Core.Enitities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MetadataService.Core.Interfaces
{
    public interface IAudioRepository
    {
        Task<AudioEntity?> GetAudioByIdAsync(int id);
        Task AddAudioAsync(AudioEntity audioEntity);
        Task UpdateAudioAsync(AudioEntity audioEntity);
        Task DeleteAudioAsync(int id);
    }
}
