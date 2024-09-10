
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
    public class AudioService: IAudioService
    {
        private readonly IAudioRepository _audioRepository;
        private readonly IStatusRepository _statusRepository;
        private readonly MessageBroker _messageBroker;

        public AudioService(
            IAudioRepository audioRepository,
            IStatusRepository statusRepository
            )
        {
            _audioRepository = audioRepository;
            _statusRepository = statusRepository;

            _messageBroker = new MessageBroker("MetadataQueue", HandleMessage);
        }
        private void HandleMessage(BrokerMessage message)
        {

            switch (message.Type)
            {
                case "UserCreated":
                    // Handle user creation event
                    break;
                case "AudioUploaded":
                    // Handle audio uploaded event
                    break;
                    // Add more message types as needed
            }
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
