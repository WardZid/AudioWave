using Amazon.S3;
using Amazon.S3.Model;
using AudioFileService.API.DTOs;
using AudioFileService.API.Services.IServices;
using System.Reflection;

namespace AudioFileService.API.Services
{
    public class UploadService(
        IAmazonS3 s3Client
        ) : IUploadService
    {
        private readonly IAmazonS3 _s3Client = s3Client;

        private readonly string bucketName = "audiowave-bucket";
        public async Task<string> UploadChunkAsync(UploadChunkDto uploadChunkDto, int uploaderId)
        {
            string s3ChunkKey = $"{uploadChunkDto.AudioId}_{uploaderId}_{uploadChunkDto.ChunkNumber}_{uploadChunkDto.TotalChunks}_{uploadChunkDto.ChunkDurationSecs}";

            var request = new PutObjectRequest()
            {
                BucketName = bucketName,
                Key = s3ChunkKey,
                InputStream = uploadChunkDto.AudioChunk.OpenReadStream()
            };
            request.Metadata.Add("Content-Type", uploadChunkDto.AudioChunk.ContentType);
            var response = await _s3Client.PutObjectAsync(request);

            return s3ChunkKey;
        }
    }
}
