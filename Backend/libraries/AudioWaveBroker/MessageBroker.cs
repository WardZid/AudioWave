using RabbitMQ.Client;
using RabbitMQ.Client.Events;
using System;
using System.Text;
using System.Text.Json;


namespace AudioWaveBroker;

public class MessageBroker
{
    private readonly IConnection _connection;
    private readonly IModel _channel;

    public MessageBroker(string queueName, Action<BrokerMessage> handleMessage)
    {
        var factory = new ConnectionFactory() { HostName = "rabbitmq" };
        _connection = factory.CreateConnection();
        _channel = _connection.CreateModel();
        _channel.QueueDeclare(queue: queueName, durable: true, exclusive: false, autoDelete: false, arguments: null);

        Consume(queueName, handleMessage);
    }

    public void Publish(string queueName, BrokerMessage message)
    {
        var serializedMessage = JsonSerializer.Serialize(message);
        var body = Encoding.UTF8.GetBytes(serializedMessage);
        _channel.BasicPublish(exchange: "", routingKey: queueName, basicProperties: null, body: body);
    }

    private void Consume(string queueName, Action<BrokerMessage> handleMessage)
    {
        var consumer = new EventingBasicConsumer(_channel);
        consumer.Received += (model, ea) =>
        {
            var body = ea.Body.ToArray();
            string message = Encoding.UTF8.GetString(body);

            if (string.IsNullOrEmpty(message)) {
                throw new ArgumentNullException("Message is NULL or Empty");
            }
            BrokerMessage deserializedMessage = JsonSerializer.Deserialize<BrokerMessage>(message);
            handleMessage(deserializedMessage);
        };
        _channel.BasicConsume(queue: queueName, autoAck: true, consumer: consumer);
    }
}
