using PlaylistService.API.Models;

namespace PlaylistService.API.Repositories
{
    public interface IPlaylistRepository
    {
        Task<List<Playlist>> GetAllAsync();
        Task<Playlist> GetByIdAsync(string playlistId);
        Task<IEnumerable<Playlist>> GetByUserIdAsync(int userId);
        Task<string> CreateAsync(Playlist playlist);
        Task UpdateAsync(Playlist playlist);
        Task DeleteAsync(string id, int userId);
        
    }
}
