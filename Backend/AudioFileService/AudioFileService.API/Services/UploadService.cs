using Amazon.S3;
using Amazon.S3.Model;
using AudioFileService.API.DTOs;
using AudioFileService.API.Services.IServices;
using AudioWaveBroker;
using System.Reflection;

namespace AudioFileService.API.Services
{
    public class UploadService: IUploadService
    {
        private readonly IAmazonS3 _s3Client;
        private readonly MessageBroker _messageBroker;

        public UploadService(IAmazonS3 s3Client)
        {
            _s3Client = s3Client;

            _messageBroker = new MessageBroker("UploadQueue", HandleMessage);

        }
        private void HandleMessage(BrokerMessage message)
        {

            switch (message.Type)
            {
                case "UserCreated":
                    // Handle user creation event
                    break;
                case "AudioUploaded":
                    // Handle audio uploaded event
                    break;
                    // Add more message types as needed
            }
        }

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

            }

            return s3ChunkKey;
        }
    }
}
