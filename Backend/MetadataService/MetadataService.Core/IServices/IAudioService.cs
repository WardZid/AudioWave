using MetadataService.Core.DTOs;
using MetadataService.Core.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MetadataService.Core.IServices
{
    public interface IAudioService
    {
        Task<Audio?> GetAudioById(int id);
        Task<IEnumerable<Audio>> GetAllAudios();
        Task<int> AddAudio(AddAudioDto audioDto);
        Task<Audio?> UpdateAudio(Audio audio);
        Task<bool> DeleteAudio(int id);
    }
}
