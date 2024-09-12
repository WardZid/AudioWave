
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
        private readonly MessageProducerService _messageProducerService;

        public AudioService(
            IAudioRepository audioRepository,
            IStatusRepository statusRepository,
            MessageProducerService messageProducerService
            )
        {
            _audioRepository = audioRepository;
            _statusRepository = statusRepository;
            _messageProducerService = messageProducerService;
        }
        private async void HandleMessage(BrokerMessage message)
        {

            switch (message.Type)
            {
                case "AudioUploaded":
                    Console.WriteLine("WARD: New AUDIO RECIEVED");
                    
                    Status newStatus = await _statusRepository.GetStatusByTitleAsync("READY");

                    int audioId = (int)message.Content.AudioId;

                    await _audioRepository.UpdateStatusAsync(audioId, newStatus);
                    break;

                case "UpdateStatus":
                    // Handle user creation event
                    break;
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
            SendTestRabbit();
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

        public void Dispose()
        {
            _messageProducerService?.Dispose();
        }

        private void SendTestRabbit()
        {

            Console.WriteLine($"TEST - Sending to RabbitMQ!");
            BrokerMessage message = new();

            message.Type = "TEST";
            message.Content = new
            {
                trial = "NONE"
            };

            _messageProducerService.Publish("MetadataQueue", message);

            Console.WriteLine($"TEST - Message sent to RabbitMQ: {message}");

        }
    }
}
