using AudioFileService.API.DTOs;

namespace AudioFileService.API.Services.IServices
{
    public interface IPlaybackService
    {
        Task<(Stream, string)> FetchChunkAsync(FetchChunkDto fetchChunkDto, int userId, string bucketName);
    }
}
