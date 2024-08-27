namespace AudioFileService.API.DTOs
{
    public class GetChunkDto
    {
        public int AudioId { get; set; }
        public int ChunkNumber { get; set; }
    }
}
