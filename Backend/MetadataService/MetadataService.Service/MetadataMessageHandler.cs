using AudioWaveBroker;
using MetadataService.Core.DTOs;
using MetadataService.Infrastructure.Models;
using MetadataService.Service.IServices;
using Microsoft.Extensions.DependencyInjection;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.Json;
using System.Threading.Tasks;

namespace MetadataService.Service;

public class MetadataMessageHandler(
    IServiceProvider serviceProvider
    ) : IMessageHandler
{
    private readonly IServiceProvider _serviceProvider = serviceProvider;

    public async Task<bool> HandleMessage(BrokerMessage brokerMessage)
    {
        Console.WriteLine($"Processing message: {brokerMessage}");

        switch (brokerMessage.Type)
        {
            case "AudioUploaded":
                Console.WriteLine("METADATA RECIEVED MESSAGE");

                var myScopedService = _serviceProvider.GetRequiredService<IAudioService>();

                AudioUploadedDto dto = JsonSerializer.Deserialize<AudioUploadedDto>(brokerMessage.SerializedContent);

                bool success = await myScopedService.UpdateAudioStatus(dto.AudioId, dto.UserId, "READY");

                Console.WriteLine($"METADATA updating status: {success}");
                return true;
        }
        return false;
    }
}
