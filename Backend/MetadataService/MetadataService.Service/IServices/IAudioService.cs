using MetadataService.Core.DTOs;
using MetadataService.Infrastructure.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MetadataService.Service.IServices
{
    public interface IAudioService
    {
        Task<Audio?> GetAudioById(int id);
        Task<Audio?> GetAudioForListen(int id);
        Task<IEnumerable<Audio>> GetAllAudios();
        Task<int> AddAudio(AddAudioDto audioDto);
        Task<Audio?> UpdateAudio(Audio audio);
        Task<bool> DeleteAudio(int id);
    }
}
