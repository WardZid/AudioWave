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

        public async Task<(Stream, string)> GetChunkAsync(GetChunkDto getChunkDto, int userId, string bucketName)
        {

            var bucketExists = await _s3Client.DoesS3BucketExistAsync(bucketName);
            if (bucketExists == false)
                throw new KeyNotFoundException("bucket");

            string s3FilePath = $"{getChunkDto.AudioId}/{getChunkDto.ChunkNumber}";
            var s3Object = await _s3Client.GetObjectAsync(bucketName, s3FilePath);

            return (s3Object.ResponseStream, s3Object.Headers.ContentType);

        }

        public async Task<(Stream, string)> GetChunksAsync(GetChunksDto getChunksDto, int userId, string bucketName)
        {
            var bucketExists = await _s3Client.DoesS3BucketExistAsync(bucketName);
            if (bucketExists == false)
                throw new KeyNotFoundException("bucket");

            var combinedStream = new MemoryStream();

            string contentType = null;

            for (int i = getChunksDto.FirstChunkNumber; i <= getChunksDto.LastChunkNumber; i++)
            {
                string s3FilePath = $"{getChunksDto.AudioId}/{i}";
                var s3Object = await _s3Client.GetObjectAsync(bucketName, s3FilePath);

                contentType ??= s3Object.Headers.ContentType; 

                await s3Object.ResponseStream.CopyToAsync(combinedStream);
                s3Object.ResponseStream.Dispose(); // Dispose of the stream once it's copied
            }

            // Reset the position of the combined stream to the beginning so it can be read
            combinedStream.Position = 0;

            return (combinedStream, contentType);
        }
    }
}
