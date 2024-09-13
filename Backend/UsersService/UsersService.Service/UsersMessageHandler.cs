﻿using AudioWaveBroker;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace UsersService.Service;

public class UsersMessageHandler(
    IServiceProvider serviceProvider
    ) : IMessageHandler
{
    private readonly IServiceProvider _serviceProvider = serviceProvider;

    public async Task<bool> HandleMessage(BrokerMessage brokerMessage)
    {
        Console.WriteLine($"Processing message: {brokerMessage}");

        switch (brokerMessage.Type)
        {
            case "TEST":
                //something happens
                // Example of resolving a scoped service
                //using (var scope = _serviceProvider.CreateScope())
                //{
                //    var myScopedService = scope.ServiceProvider.GetRequiredService<IMyScopedService>();
                //    // Use myScopedService here
                //}
                Console.WriteLine("USERS RECIEVED MESSAGE");
                return true;
        }
        return false;
    }
}