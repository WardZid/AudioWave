using AudioWaveBroker;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MetadataService.Service;

public class MetadataMessageHandler(
    IServiceProvider serviceProvider
    ) : IMessageHandler
{
    private readonly IServiceProvider _serviceProvider = serviceProvider;

    public Task HandleMessage(BrokerMessage brokerMessage)
    {
        Console.WriteLine($"Processing message: {brokerMessage}");
        
        switch (brokerMessage.Type)
        {
            case "AudioUploaded":
                //something happens
                // Example of resolving a scoped service
                //using (var scope = _serviceProvider.CreateScope())
                //{
                //    var myScopedService = scope.ServiceProvider.GetRequiredService<IMyScopedService>();
                //    // Use myScopedService here
                //}
                Console.WriteLine("METADATA RECIEVED MESSAGE");
                break;
        }
        return Task.CompletedTask;
    }
}
