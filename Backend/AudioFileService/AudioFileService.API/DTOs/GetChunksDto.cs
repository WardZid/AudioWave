namespace AudioFileService.API.DTOs
{
    public class GetChunksDto
    {
        public int AudioId { get; set; }
        public int FirstChunkNumber { get; set; }
        public int LastChunkNumber { get; set; }

    }
}
