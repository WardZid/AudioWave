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
        Task<Audio?> GetAudioById(int audioId, int userId);
        Task<Audio?> GetAudioForListen(int audioId, int userId);
        Task<IEnumerable<Audio>> GetAllAudios();
        Task<IEnumerable<Audio>> GetAllAudiosByUserID(int uploaderId, int userId);
        Task<int> AddAudio(AddAudioDto audioDto, int uploaderId);
        Task<Audio?> UpdateAudio(Audio audio, int userId);
        Task<bool> DeleteAudio(int audioId, int userId);
        Task<bool> UpdateAudioStatus(int audioId, int userId, string statusName);
    }
}
