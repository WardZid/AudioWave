using Amazon.S3;
using Amazon.S3.Model;
using AudioFileService.API.DTOs;
using AudioFileService.API.Services.IServices;
using AudioWaveBroker;
using System.Reflection;

namespace AudioFileService.API.Services
{
    public class UploadService(
            IAmazonS3 s3Client,
            MessageProducerService messageProducerService
        ) : IUploadService, IDisposable
    {

        private readonly IAmazonS3 _s3Client = s3Client;
        private readonly MessageProducerService _messageProducerService = messageProducerService;

        private readonly List<string> allowedAudioMimeTypes = new List<string>
        {
            "audio/mpeg",    // MP3
            "audio/wav",     // WAV
            "audio/x-wav",   // WAV
            "audio/ogg",     // OGG
            "audio/flac",    // FLAC
            "audio/mp4",     // MP4
            "audio/aac",     // AAC
            "audio/x-aac",   // AAC
        };

        public async Task<string> UploadChunkAsync(UploadChunkDto uploadChunkDto, int uploaderId, string bucketName)
        {
            if (allowedAudioMimeTypes.Contains(uploadChunkDto.AudioChunk.ContentType) == false)
            {
                throw new Exception("Bad file format. The file needs to be an audio file.");
            }

            //TODO possibly convert all audio chunks to one select type

            //audioid as dir and chunk-num as file name
            string s3ChunkKey = $"{uploadChunkDto.AudioId}/{uploadChunkDto.ChunkNumber}";

            var request = new PutObjectRequest()
            {
                BucketName = bucketName,
                Key = s3ChunkKey,
                InputStream = uploadChunkDto.AudioChunk.OpenReadStream()
            };
            request.Metadata.Add("Content-Type", uploadChunkDto.AudioChunk.ContentType);
            var response = await _s3Client.PutObjectAsync(request);

            if (uploadChunkDto.ChunkNumber == uploadChunkDto.TotalChunks)
            {

                Console.WriteLine($"Sending to RabbitMQ!");

                BrokerMessage message = new();

                message.Type = "AudioUploaded";
                message.Content = new
                {
                    AudioId = uploadChunkDto.AudioId
                };

                _messageProducerService.Publish("MetadataQueue", message);

                Console.WriteLine($"Message sent to RabbitMQ: {message}");
            }

            return s3ChunkKey;
        }

        public void Dispose()
        {
            _messageProducerService?.Dispose();
        }
    }
}
