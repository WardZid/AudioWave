using System.ComponentModel.DataAnnotations;

namespace AudioFileService.API.DTOs
{
    public class UploadChunkDto
    {
        public required int AudioId { get; set; }
        public required int ChunkNumber { get; set; }
        public required int TotalChunks { get; set; }
        public required int ChunkDurationSecs { get; set; }
        public required IFormFile AudioChunk { get; set; }
    }
}
