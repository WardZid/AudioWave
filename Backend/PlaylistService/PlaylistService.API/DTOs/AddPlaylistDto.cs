using MongoDB.Bson.Serialization.Attributes;
using PlaylistService.API.Models;

namespace PlaylistService.API.DTOs
{
    public class AddPlaylistDto
    {
        public List<int> AudioIds { get; set; }
        public string PlaylistName { get; set; }
        public AccessLevel AccessLevel { get; set; } = AccessLevel.Private;  // Default to Private
    }
}
