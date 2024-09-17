using MongoDB.Driver;
using PlaylistService.API.Models;
using PlaylistService.API.Services;
using PlaylistService.API.Settings;

namespace PlaylistService.API.Repositories
{
    public class PlaylistRepository : IPlaylistRepository
    {
        private readonly IMongoCollection<Playlist> _playlists;

        public PlaylistRepository(MongoDbService mongoDbService)
        {
            _playlists = mongoDbService.GetPlaylists();
        }

        public async Task<List<Playlist>> GetAllAsync() =>
            await _playlists.Find(playlist => true).ToListAsync();

        public async Task<Playlist> GetByIdAsync(string playlistId) =>
            await _playlists.Find(playlist => playlist.Id == playlistId).FirstOrDefaultAsync();
        public async Task<IEnumerable<Playlist>> GetByUserIdAsync(int userId) =>
            await _playlists.Find(playlist => playlist.UserId == userId).ToListAsync();

        public async Task<string> CreateAsync(Playlist playlist){
            await _playlists.InsertOneAsync(playlist);
            return playlist.Id;
        }

        public async Task UpdateAsync(Playlist updatedPlaylist) =>
            await _playlists.ReplaceOneAsync(playlist => playlist.Id == updatedPlaylist.Id, updatedPlaylist);

        public async Task DeleteAsync(string id, int userId) =>
            await _playlists.DeleteOneAsync(playlist => playlist.Id == id && playlist.UserId == userId);
    }
}
