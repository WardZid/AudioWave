using System.ComponentModel.DataAnnotations;

namespace AudioFileService.API.DTOs
{
    public class UploadChunkDto
    {
        public required string AudioId { get; set; }
        public int ChunkNumber { get; set; }
        public int TotalChunks { get; set; }
        public int ChunkDurationSecs { get; set; }
        public required IFormFile AudioChunk { get; set; }
    }
}
