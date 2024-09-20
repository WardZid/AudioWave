using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Hosting;
using RabbitMQ.Client;
using RabbitMQ.Client.Events;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.Json;
using System.Threading.Tasks;



namespace AudioWaveBroker;

public class MessageConsumerService : IHostedService, IDisposable
{
    private IModel _channel;
    private IConnection _connection;
    private readonly IConfiguration _configuration;
    private readonly IMessageHandler _messageHandler;

    public MessageConsumerService(
        IConfiguration configuration,
        IMessageHandler messageHandler
        )
    {
        _configuration = configuration;
        _messageHandler = messageHandler;
        InitializeRabbitMq();
    }

    private void InitializeRabbitMq()
    {
        var rabbitMqSettings = _configuration.GetSection("RabbitMQ");
        var retryCount = 0;
        var maxRetries = 10; // set it to -1 for infinite retries.
        var retryDelay = TimeSpan.FromSeconds(10); // retry delay

        while (true)
        {
            try
            {
                Console.WriteLine($"Attempting to connect to RabbitMQ. Attempt #{retryCount + 1}");

                var factory = new ConnectionFactory
                {
                    HostName = rabbitMqSettings["HostName"],
                    Port = int.Parse(rabbitMqSettings["Port"])
                };

                _connection = factory.CreateConnection();
                _channel = _connection.CreateModel();
                _channel.QueueDeclare(rabbitMqSettings["ConsumerQueue"],
                    durable: false,
                    exclusive: false,
                    autoDelete: false,
                    arguments: null);

                Console.WriteLine("Connected to RabbitMQ successfully.");
                break; //successful connection
            }
            catch (Exception ex)
            {
                retryCount++;
                Console.WriteLine($"ERROR: Failed to connect to RabbitMQ: {ex.Message}");

                if (retryCount == maxRetries)
                {
                    throw new Exception("ERROR: Max retry attempts exceeded. Could not connect to RabbitMQ.", ex);
                }

                Console.WriteLine("Retrying in 10 seconds...");
                Thread.Sleep(retryDelay); // Wait for the specified retry delay before trying again
            }
        }
    }


    public Task StartAsync(CancellationToken cancellationToken)
    {
        var consumer = new EventingBasicConsumer(_channel);
        consumer.Received += async (model, ea) =>
        {
            var body = ea.Body.ToArray();
            var message = Encoding.UTF8.GetString(body);
            Console.WriteLine($"Received message: {message}");

            BrokerMessage deserializedMessage = JsonSerializer.Deserialize<BrokerMessage>(message);
            bool success = await _messageHandler.HandleMessage(deserializedMessage);


            _channel.BasicAck(ea.DeliveryTag, false);
            Console.WriteLine($"Message Processing {(success ? "Success" : "Failure")} - ACK Delivered");
        };

        var queueName = _configuration["RabbitMQ:ConsumerQueue"];
        _channel.BasicConsume(
            queue: queueName,
            autoAck: false,
            consumer: consumer);

        return Task.CompletedTask;
    }

    public Task StopAsync(CancellationToken cancellationToken)
    {
        Dispose(); // Clean up RabbitMQ resources.
        return Task.CompletedTask;
    }

    public void Dispose()
    {
        _channel?.Close();
        _connection?.Close();
    }
}
