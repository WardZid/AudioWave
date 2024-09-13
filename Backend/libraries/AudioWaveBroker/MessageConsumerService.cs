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
        try
        {

            var rabbitMqSettings = _configuration.GetSection("RabbitMQ");
            Console.WriteLine(rabbitMqSettings.ToString());
            var factory = new ConnectionFactory
            {
                HostName = rabbitMqSettings["HostName"],
                //ClientProvidedName = rabbitMqSettings["ClientProvidedName"],
                Port = int.Parse(rabbitMqSettings["Port"])
            };
            Console.WriteLine(rabbitMqSettings["HostName"]);
            _connection = factory.CreateConnection();
            _channel = _connection.CreateModel();
            _channel.QueueDeclare(rabbitMqSettings["ConsumerQueue"],
                durable: false,
                exclusive: false,
                autoDelete: false,
                arguments: null);
        }
        catch (Exception ex)
        {
            throw new Exception($"ERROR: AudioWaveBroker cannot initialize for whatever reason: {ex.Message}", ex);
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
