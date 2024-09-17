namespace PlaylistService.API.DTOs
{
    public class RemoveAudioDto
    {
        public string PlaylistId { get; set; }
        public List<int> AudioIds { get; set; }
    }
}
