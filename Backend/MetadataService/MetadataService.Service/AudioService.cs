
using MetadataService.Core.DTOs;
using MetadataService.Infrastructure.IRepositories;
using MetadataService.Service.IServices;
using MetadataService.Infrastructure.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MetadataService.Service
{
    public class AudioService(
        IAudioRepository audioRepository
        ) : IAudioService
    {
        private readonly IAudioRepository _audioRepository = audioRepository;

        public async Task<int> AddAudio(AddAudioDto audioDto)
        {
            var audio = new Audio
            {
                Title = audioDto.Title,
                Description = audioDto.Description,
                Thumbnail = audioDto.Thumbnail,
                DurationSec = audioDto.DurationSec,
                FileSize = audioDto.FileSize,
                FileType = audioDto.FileType,
                VisibilityId = audioDto.VisibilityId
            };

            var addedAudio = await _audioRepository.AddAsync(audio);
            return addedAudio.Id; 
        }

        public async Task<Audio?> GetAudioById(int id)
        {
            return await _audioRepository.GetByIdAsync(id);
        }


        public async Task<Audio?> GetAudioForListen(int id)
        {
            // Increment listen count
            await _audioRepository.AddListenAsync(id);

            return await _audioRepository.GetByIdAsync(id);
        }

        public async Task<IEnumerable<Audio>> GetAllAudios()
        {
            return await _audioRepository.GetAllAsync();
        }

        public async Task<Audio?> UpdateAudio(Audio audio)
        {
            var existingAudio = await _audioRepository.GetByIdAsync(audio.Id);
            if (existingAudio == null)
            {
                return null;
            }

            return await _audioRepository.UpdateAsync(audio);
        }

        public async Task<bool> DeleteAudio(int id)
        {
            return await _audioRepository.DeleteAsync(id);
        }
    }
}
