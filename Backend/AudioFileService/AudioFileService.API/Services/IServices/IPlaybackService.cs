using AudioFileService.API.DTOs;

namespace AudioFileService.API.Services.IServices
{
    public interface IPlaybackService
    {
        Task<(Stream, string)> GetChunkAsync(GetChunkDto getChunkDto, int userId, string bucketName);
        Task<(Stream, string)> GetChunksAsync(GetChunksDto getChunksDto, int userId, string bucketName);
    }
}
