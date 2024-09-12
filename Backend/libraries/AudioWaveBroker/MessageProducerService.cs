using Microsoft.Extensions.Configuration;
using RabbitMQ.Client;
using RabbitMQ.Client.Events;
using System;
using System.Data.Common;
using System.Reflection;
using System.Text;
using System.Text.Json;
using System.Threading.Channels;


namespace AudioWaveBroker;

public class MessageProducerService
{

    private IModel _channel;
    private IConnection _connection;
    private readonly IConfiguration _configuration;


    public MessageProducerService(IConfiguration configuration)
    {
        _configuration = configuration;
    }
    //private void InitializeRabbitMq()
    //{

    //}

    public void Publish(string queueName, BrokerMessage message)
    {
        var rabbitMqSettings = _configuration.GetSection("RabbitMQ");
        var factory = new ConnectionFactory
        {
            HostName = rabbitMqSettings["HostName"],
            ClientProvidedName = rabbitMqSettings["ClientProvidedName"],
            Port = int.Parse(rabbitMqSettings["Port"])
        };
        _connection = factory.CreateConnection();
        _channel = _connection.CreateModel();

        //_channel.QueueDeclare(rabbitMqSettings["ConsumerQueue"],
        //    durable: false,
        //    exclusive: false,
        //    autoDelete: false,
        //    arguments: null);


        try
        {
            var serializedMessage = JsonSerializer.Serialize(message);
            var body = Encoding.UTF8.GetBytes(serializedMessage);

            //_channel.ExchangeDeclare(rabbitMqSettings["Port"], ExchangeType.Direct);

            _channel.QueueDeclare(queue: queueName,
                durable: false,
                exclusive: false, 
                autoDelete: false);

            _channel.BasicPublish(exchange: "",
                routingKey: queueName,
                basicProperties: null,
                body: body);

        }
        catch (Exception ex)
        {
            throw new Exception("Problem with publishing message: " + ex.Message);
        }
        finally
        {
            _connection?.Close();
        }
    }
    public void Dispose()
    {
        Console.WriteLine("Disposing of message producer");
        _channel?.Close();
        _channel?.Dispose();
        _connection?.Close();
        _connection?.Dispose();
    }
}
