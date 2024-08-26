using AudioFileService.API.DTOs;

namespace AudioFileService.API.Services.IServices
{
    public interface IUploadService
    {
        Task<string> UploadChunkAsync(UploadChunkDto uploadChunkRequest, int uploaderId, string bucketName);
    }
}
