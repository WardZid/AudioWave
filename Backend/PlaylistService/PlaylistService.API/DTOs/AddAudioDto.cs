namespace PlaylistService.API.DTOs
{
    public class AddAudioDto
    {
        public string PlaylistId { get; set; }
        public HashSet<int> AudioIds { get; set; }
    }
}
