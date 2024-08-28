using Microsoft.Extensions.Configuration;
using MongoDB.Bson;
using MongoDB.Driver;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Cryptography;
using System.Text;
using System.Text.Json;
using System.Threading.Tasks;

namespace UsersService.Service
{
    public class AuthEncryptionService
    {
        private readonly IConfiguration _configuration;
        private MongoClient _mongoClient;
        private readonly RSA _rsa;

        public string PublicKey { get; set; }
        public string PrivateKey { get; set; }

        public AuthEncryptionService(IConfiguration configuration)
        {
            _configuration = configuration;
            InitializeMongoClient();
            if (CheckConnection() == false)
            {
                throw new Exception("Unable to reach Credential Secrets server");
            }
            FetchRsaKeys();
            _rsa = RSA.Create();
            LoadPrivateKey(PrivateKey);
        }

        private void InitializeMongoClient()
        {
            string connectionUri = _configuration.GetConnectionString("MONGO_CRED_SECRET_CONN");
            if (!string.IsNullOrEmpty(connectionUri))
            {
                var settings = MongoClientSettings.FromConnectionString(connectionUri);
                settings.ServerApi = new ServerApi(ServerApiVersion.V1);
                _mongoClient = new MongoClient(settings);
            }
            else
            {
                throw new Exception("Error: Cred Secrets connection string is not set.");
            }
        }

        private bool CheckConnection()
        {
            if (_mongoClient == null)
            {
                Console.WriteLine("MongoClient is not initialized.");
                return false;
            }


            try
            {
                var result = _mongoClient.GetDatabase("credential-secrets").RunCommand<BsonDocument>(new BsonDocument("ping", 1));
                Console.WriteLine("Pinged your deployment. You successfully connected to MongoDB!");
                return true;
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Error connecting to MongoDB: {ex.Message}");
            }
            return false;
        }

        private void FetchRsaKeys()
        {
            try
            {
                var database = _mongoClient.GetDatabase("credential-secrets");
                var collection = database.GetCollection<BsonDocument>("rsa-keys");

                // Retrieve the most recent document
                var filter = Builders<BsonDocument>.Filter.Empty;
                var sort = Builders<BsonDocument>.Sort.Descending("createdAt");
                var latestKeys = collection.Find(filter).Sort(sort).FirstOrDefault();

                if (latestKeys != null)
                {

                    string publicKey = latestKeys.GetValue("publicKey").AsString;
                    string privateKey = latestKeys.GetValue("privateKey").AsString;

                    PublicKey = publicKey;
                    PrivateKey = privateKey;
                }
                else
                {
                    Console.WriteLine("No RSA keys found in the database.");
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Error fetching RSA keys: {ex.Message}");
            }
        }

        private void LoadPrivateKey(string privateKey)
        {
            if (string.IsNullOrEmpty(privateKey))
            {
                throw new Exception("Private key is not set.");
            }

            try
            {
                var privateKeyBytes = Convert.FromBase64String(privateKey);
                _rsa.ImportRSAPrivateKey(privateKeyBytes, out _);
            }
            catch (Exception ex)
            {
                throw new Exception("Error loading private key.", ex);
            }
        }

        public T DecryptObject<T>(string encryptedText)
        {
            try
            {
                byte[] encryptedBytes = Convert.FromBase64String(encryptedText);

                byte[] decryptedBytes = _rsa.Decrypt(encryptedBytes, RSAEncryptionPadding.Pkcs1); // Decrypt using PKCS#1 v1.5 padding

                string decryptedJson = Encoding.UTF8.GetString(decryptedBytes).Trim(); // Convert decrypted bytes to string (JSON)

                var options = new JsonSerializerOptions
                {
                    PropertyNameCaseInsensitive = true,
                };

                T result = JsonSerializer.Deserialize<T>(decryptedJson, options); // Deserialize JSON to DTO object

                return result;
            }
            catch (CryptographicException ex)
            {
                Console.WriteLine($"Error during decryption: {ex.Message}");
                throw;
            }
            catch (JsonException ex)
            {
                Console.WriteLine($"Error during JSON deserialization: {ex.Message}");
                throw;
            }
        }
    }
}
