
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
using MetadataService.Infrastructure.Repositories;

namespace MetadataService.Service
{
    public class AudioService : IAudioService, IDisposable
    {
        private readonly IAudioRepository _audioRepository;
        private readonly IStatusRepository _statusRepository;
        private readonly IListenRepository _listenRepository;
        private readonly IVisibilityRepository _visibilityRepository;
        private readonly MessageProducerService _messageProducerService;

        public AudioService(
            IAudioRepository audioRepository,
            IStatusRepository statusRepository,
            IListenRepository listenRepository,
            IVisibilityRepository visibilityRepository,
            MessageProducerService messageProducerService
            )
        {
            _audioRepository = audioRepository;
            _statusRepository = statusRepository;
            _listenRepository = listenRepository;
            _visibilityRepository = visibilityRepository;
            _messageProducerService = messageProducerService;
        }

        public void Dispose()
        {
            _messageProducerService?.Dispose();
        }

        public async Task<int> AddAudio(AddAudioDto audioDto, int uploaderId)
        {
            Status uploadingStatus = await _statusRepository.GetStatusByTitleAsync("UPLOADING");


            var tagsNoDupes = audioDto.Tags != null ? new HashSet<string>(audioDto.Tags) : new HashSet<string>();

            List<Tag> tags = tagsNoDupes.Select(tagString => new Tag
            {
                Tag1 = tagString

            })
                .ToList();

            var audio = new Audio
            {
                Title = audioDto.Title,
                Description = audioDto.Description,
                Thumbnail = audioDto.Thumbnail,
                DurationSec = audioDto.DurationSec,
                FileSize = audioDto.FileSize,
                FileType = audioDto.FileType,
                FileChecksum = audioDto.FileChecksum,
                VisibilityId = audioDto.VisibilityId ?? (await _visibilityRepository.GetByTitleAsync("Private")).Id, // if null get the id of the private visibility
                StatusId = uploadingStatus.Id,
                Listens = 0,
                UploadedAt = DateTime.Now,
                UploaderId = uploaderId,
                Tags = tags
            };

            var addedAudio = await _audioRepository.AddAsync(audio);

            return addedAudio.Id;
        }

        public async Task<Audio?> GetAudioById(int audioId, int userId)
        {
            Audio? audio = await _audioRepository.GetByIdAsync(audioId);

            if (audio == null)
            {
                throw new KeyNotFoundException();
            }

            Visibility? visibility = await _visibilityRepository.GetByIdAsync(audio.VisibilityId);
            if (visibility == null)
            {
                throw new KeyNotFoundException();
            }

            if (visibility.Visibility1 == "Private" && audio.UploaderId != userId)
            {
                throw new KeyNotFoundException();
            }
            return audio;
        }

        public async Task<Audio?> GetAudioForListen(int audioId, int userId)
        {

            Audio? audio = await _audioRepository.GetByIdAsync(audioId);

            if (audio == null)
            {
                throw new KeyNotFoundException();
            }

            Visibility? visibility = await _visibilityRepository.GetByIdAsync(audio.VisibilityId);
            if (visibility == null)
            {
                throw new KeyNotFoundException();
            }

            if (visibility.Visibility1 == "Private" && audio.UploaderId != userId)
            {
                throw new KeyNotFoundException();
            }


            // Increment listen count
            await _audioRepository.AddListenAsync(audioId);

            if (userId > 0)
            {
                await _listenRepository.AddAsync(audioId, userId);
            }


            return audio;
        }

        public async Task<IEnumerable<Audio>> GetAllAudios()
        {
            return await _audioRepository.GetAllAsync();
        }
        public async Task<IEnumerable<Audio>> GetAllAudiosByUserID(int uploaderId, int userId)
        {
            IEnumerable<Audio> audios = await _audioRepository.GetByUserIdAsync(uploaderId);

            if(uploaderId != userId)
            {
                Visibility publicVis = await _visibilityRepository.GetByTitleAsync("Public");
                audios = audios.Where(a => a.VisibilityId == publicVis.Id);
            }
            return audios;

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

        public async Task<bool> DeleteAudio(int audioId, int userId)
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
