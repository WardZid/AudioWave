﻿using AudioWaveBroker;
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

        public async Task<Playlist> GetByIdAsync(string playlistId, int userId)
        {
            Playlist playlist = await _playlistRepository.GetByIdAsync(playlistId);

            if (playlist.AccessLevel == AccessLevel.Private && playlist.UserId != userId)
            {
                throw new KeyNotFoundException();
            }
            return playlist;
        }
        public async Task<IEnumerable<Playlist>> GetByUploaderIdAsync(int uploaderId, int userId)
        {
            List<Playlist> playlists = (await _playlistRepository.GetByUserIdAsync(uploaderId)).ToList();

            if(uploaderId != userId)
            {
                //filter playlists
                playlists = playlists.Where(p => p.AccessLevel == AccessLevel.Public).ToList();
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


            playlist.AudioIds.UnionWith(addAudioToPlaylistDto.AudioIds);
            await _playlistRepository.UpdateAsync(playlist);
        }

        public async Task RemoveAudioAsync(RemoveAudioDto removeAudioDto, int userId)
        {
            Playlist playlist = await _playlistRepository.GetByIdAsync(removeAudioDto.PlaylistId);

            if (playlist.UserId != userId)
            {
                throw new UnauthorizedAccessException("Removing from Playlist unauthorized");
            }


            playlist.AudioIds.ExceptWith(removeAudioDto.AudioIds);

            await _playlistRepository.UpdateAsync(playlist);
        }

        public async Task<IEnumerable<KeyValuePair<string, int>>> GetAccessLevels()
        {
            var accessLevels = Enum.GetValues(typeof(AccessLevel))
                                    .Cast<AccessLevel>()
                                    .Select(al => new KeyValuePair<string, int>(al.ToString(), (int)al))
                                    .ToList();

            return accessLevels;
        }

    }
}
