namespace PlaylistService.API.DTOs
{
    public class AddAudioDto
    {
        public string PlaylistId { get; set; }
        public List<int> AudioId { get; set; }
    }
}
