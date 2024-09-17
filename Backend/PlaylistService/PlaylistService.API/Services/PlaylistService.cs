using AudioWaveBroker;
using PlaylistService.API.DTOs;
using PlaylistService.API.Models;
using PlaylistService.API.Repositories;

namespace PlaylistService.API.Services
{
    public class PlaylistService(
        IPlaylistRepository playlistRepository,
        MessageProducerService messageProducerService
        ) : IPlaylistService
    {
        private readonly IPlaylistRepository _playlistRepository = playlistRepository;
        private readonly MessageProducerService _messageProducerService = messageProducerService;

        public async Task<List<Playlist>> GetAllAsync()
        {
            return await _playlistRepository.GetAllAsync();
        }

        public async Task<Playlist> GetByIdAsync(string id)
        {
            return await _playlistRepository.GetByIdAsync(id);
        }
        public async Task<IEnumerable<Playlist>> GetByUploaderIdAsync(int uploaderId, int userId)
        {
            List<Playlist> playlists = (await _playlistRepository.GetByUserIdAsync(uploaderId)).ToList();

            if(uploaderId != userId)
            {
                //filter playlists
                playlists = playlists.Where(p => p.AccessLevel != AccessLevel.Private).ToList();
            }
            return playlists;
        }

        public async Task<string> CreateAsync(AddPlaylistDto addPlaylistDto, int userId)
        {
            Playlist newPlaylist = new();

            newPlaylist.PlaylistName = addPlaylistDto.PlaylistName;
            newPlaylist.UserId = userId;
            newPlaylist.AudioIds = addPlaylistDto.AudioIds;
            newPlaylist.CreationDate = DateTime.UtcNow;
            newPlaylist.UpdateDate = DateTime.UtcNow;
            newPlaylist.AccessLevel = addPlaylistDto.AccessLevel;

            string playlistId = await _playlistRepository.CreateAsync(newPlaylist);
            return playlistId;
        }


        public async Task UpdateAsync(UpdatePlaylistDto updatePlaylistDto, int userId)
        {
            Playlist existingPlaylist = await _playlistRepository.GetByIdAsync(updatePlaylistDto.PlaylistId);
            if (existingPlaylist == null)
            {
                throw new Exception("Playlist not found");
            }
            if (existingPlaylist.UserId != userId)
            {
                throw new UnauthorizedAccessException("Playlist updating unauthorized");
            }
            
            existingPlaylist.PlaylistName = updatePlaylistDto.PlaylistName;
            existingPlaylist.AudioIds = updatePlaylistDto.AudioIds;
            existingPlaylist.UpdateDate = DateTime.UtcNow;
            existingPlaylist.AccessLevel = updatePlaylistDto.AccessLevel;
            await _playlistRepository.UpdateAsync(existingPlaylist);
        }

        public async Task DeleteAsync(DeletePlaylistDto deletePlaylistDto, int userId)
        {
            await _playlistRepository.DeleteAsync(deletePlaylistDto.PlaylistId, userId);
        }

        public async Task AddAudioAsync(AddAudioDto addAudioToPlaylistDto, int userId)
        {

            Playlist playlist = await _playlistRepository.GetByIdAsync(addAudioToPlaylistDto.PlaylistId);

            if (playlist.UserId != userId)
            {
                throw new UnauthorizedAccessException("Adding to Playlist unauthorized");
            }

            playlist.AudioIds.AddRange(addAudioToPlaylistDto.AudioId);
            await _playlistRepository.UpdateAsync(playlist);
        }

        public async Task RemoveAudioAsync(RemoveAudioDto removeAudioDto, int userId)
        {
            throw new NotImplementedException();
        }
    }
}
