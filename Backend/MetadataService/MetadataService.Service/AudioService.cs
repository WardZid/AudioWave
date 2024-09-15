
using MetadataService.Core.DTOs;
using MetadataService.Infrastructure.IRepositories;
using MetadataService.Service.IServices;
using MetadataService.Infrastructure.Models;
using AudioWaveBroker;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Text.Json;

namespace MetadataService.Service
{
    public class AudioService : IAudioService, IDisposable
    {
        private readonly IAudioRepository _audioRepository;
        private readonly IStatusRepository _statusRepository;
        private readonly IListenRepository _listenRepository;
        private readonly MessageProducerService _messageProducerService;

        public AudioService(
            IAudioRepository audioRepository,
            IStatusRepository statusRepository,
            IListenRepository listenRepository,
            MessageProducerService messageProducerService
            )
        {
            _audioRepository = audioRepository;
            _statusRepository = statusRepository;
            _listenRepository = listenRepository;
            _messageProducerService = messageProducerService;
        }

        public void Dispose()
        {
            _messageProducerService?.Dispose();
        }

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

        public async Task<Audio?> GetAudioForListen(int audioId, int userId)
        {
            // Increment listen count
            await _audioRepository.AddListenAsync(audioId);

            if (userId > 0)
            {
                await _listenRepository.AddAsync(audioId, userId);
            }

            return await _audioRepository.GetByIdAsync(audioId);
        }

        public async Task<IEnumerable<Audio>> GetAllAudios()
        {
            return await _audioRepository.GetAllAsync();
        }

        public async Task<Audio?> UpdateAudio(Audio audio, int userId)
        {
            var existingAudio = await _audioRepository.GetByIdAsync(audio.Id);
            if (existingAudio == null)
            {
                return null;
            }

            return await _audioRepository.UpdateAsync(audio, userId);
        }

        public async Task<bool> DeleteAudio(int audioId,int userId)
        {
            return await _audioRepository.DeleteAsync(audioId, userId);
        }

        public async Task<bool> UpdateAudioStatus(int audioId, int userId, string statusName)
        {
            Status newStatus = await _statusRepository.GetStatusByTitleAsync(statusName); // Example: "READY"

            //int audioId = (int)message.Content.AudioId;
            Audio audio = await _audioRepository.GetByIdAsync(audioId);

            if (audio == null)
            {
                return false;
            }
            audio.StatusId = newStatus.Id;

            Audio resultAudio = await _audioRepository.UpdateAsync(audio, userId);
            return resultAudio.StatusId == newStatus.Id;
        }
    }
}
