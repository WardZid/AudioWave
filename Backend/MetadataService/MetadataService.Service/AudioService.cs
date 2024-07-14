
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
        IAudioRepository audioRepository,
        IStatusRepository statusRepository
        ) : IAudioService
    {
        private readonly IAudioRepository _audioRepository = audioRepository;
        private readonly IStatusRepository _statusRepository = statusRepository;

        public async Task<int> AddAudio(AddAudioDto audioDto, int uploaderId)
        {
            Status uploadingStatus = await _statusRepository.GetStatusByTitleAsync("UPLOADING");
            var audio = new Audio
            {
                Title = audioDto.Title,
                Description = audioDto.Description,
                Thumbnail = audioDto.Thumbnail,
                DurationSec = audioDto.DurationSec,
                FileSize = audioDto.FileSize,
                FileType = audioDto.FileType,
                FileChecksum = audioDto.FileChecksum,
                VisibilityId = audioDto.VisibilityId,
                StatusId = uploadingStatus.Id,
                Listens = 0,
                UploadedAt = DateTime.Now,
                UploaderId = uploaderId

            };

            var addedAudio = await _audioRepository.AddAsync(audio);

            return addedAudio.Id;
        }

        public async Task<Audio?> GetAudioById(int audioId)
        {
            return await _audioRepository.GetByIdAsync(audioId);
        }


        public async Task<Audio?> GetAudioForListen(int audioId)
        {
            // Increment listen count
            await _audioRepository.AddListenAsync(audioId);

            return await _audioRepository.GetByIdAsync(audioId);
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

        public async Task<bool> DeleteAudio(int audioId)
        {
            return await _audioRepository.DeleteAsync(audioId);
        }
    }
}
