using PlaylistService.API.Models;

namespace PlaylistService.API.DTOs
{
    public class UpdatePlaylistDto
    {
        public string PlaylistId { get; set; }
        public string PlaylistName { get; set; }
        public AccessLevel AccessLevel { get; set; } = AccessLevel.Private;  // Default to Private
    }
}
