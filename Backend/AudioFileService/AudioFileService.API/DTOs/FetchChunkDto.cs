namespace AudioFileService.API.DTOs
{
    public class FetchChunkDto
    {
        public int AudioId { get; set; }
        public int ChunkNumber { get; set; }
    }
}
