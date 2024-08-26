using Amazon.S3;
using AudioFileService.API.DTOs;
using AudioFileService.API.Services.IServices;
using Microsoft.AspNetCore.DataProtection.KeyManagement;

namespace AudioFileService.API.Services
{
    public class PlaybackService(
        IAmazonS3 s3Client
        ) : IPlaybackService
    {
        private readonly IAmazonS3 _s3Client = s3Client;

        public async Task<(Stream, string)> FetchChunkAsync(FetchChunkDto fetchChunkDto, int userId, string bucketName)
        {

            var bucketExists = await _s3Client.DoesS3BucketExistAsync(bucketName);
            if (bucketExists == false)
                throw new KeyNotFoundException("bucket");

            string s3FilePath = $"{fetchChunkDto.AudioId}/{fetchChunkDto.ChunkNumber}";
            var s3Object = await _s3Client.GetObjectAsync(bucketName, s3FilePath);

            return (s3Object.ResponseStream, s3Object.Headers.ContentType);

        }
    }
}
