using PlaylistService.API.DTOs;
using PlaylistService.API.Models;

namespace PlaylistService.API.Services
{
    public interface IPlaylistService
    {
        Task<List<Playlist>> GetAllAsync();
        Task<Playlist> GetByIdAsync(string id);
        Task<IEnumerable<Playlist>> GetByUploaderIdAsync(int uploaderId, int userId);

        Task<string> CreateAsync(AddPlaylistDto addPlaylistDto, int userId);
        Task UpdateAsync(UpdatePlaylistDto updatePlaylistDto, int userId);
        Task DeleteAsync(DeletePlaylistDto deletePlaylistDto, int userId);

        Task AddAudioAsync(AddAudioDto addAudioToPlaylistDto, int userId);
        Task RemoveAudioAsync(RemoveAudioDto removeAudioDto, int userId);
    }
}
