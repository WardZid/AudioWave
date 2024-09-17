using MongoDB.Bson;
using MongoDB.Driver;
using PlaylistService.API.Models;

namespace PlaylistService.API.Services
{
    public class MongoDbService
    {
        private readonly IConfiguration _configuration;
        private MongoClient _mongoClient;
        private readonly IMongoCollection<Playlist> _playlists;

        public MongoDbService(IConfiguration configuration)
        {
            _configuration = configuration;
            InitializeMongoClient();
            if (CheckConnection() == false)
            {
                throw new Exception("Unable to reach Playlists DB server");
            }
            _playlists = GetCollection<Playlist>("PlaylistsDB", "Playlists");
        }
        private void InitializeMongoClient()
        {
            string connectionUri = _configuration.GetConnectionString("PLAYLIST_CONN");
            if (!string.IsNullOrEmpty(connectionUri))
            {
                var settings = MongoClientSettings.FromConnectionString(connectionUri);
                settings.ServerApi = new ServerApi(ServerApiVersion.V1);
                _mongoClient = new MongoClient(settings);
            }
            else
            {
                throw new Exception("Error: Playlist Cluster Corrupt or Unreachable.");
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
                var result = _mongoClient.GetDatabase("PlaylistsDB").RunCommand<BsonDocument>(new BsonDocument("ping", 1));
                Console.WriteLine("Pinged your deployment. You successfully connected to MongoDB!");
                return true;
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Error connecting to MongoDB: {ex.Message}");
            }
            return false;
        }

        private IMongoCollection<T> GetCollection<T>(string databaseName, string collectionName)
        {
            try
            {
                var database = _mongoClient.GetDatabase(databaseName);
                IMongoCollection<T> collection = database.GetCollection<T>(collectionName);
                return collection;
            }
            catch (Exception ex)
            {
                throw new Exception($"ERROR : MongoDB - Could not fetch {collectionName} Collection", ex);
            }
        }
        public IMongoCollection<Playlist> GetPlaylists()
        {
            return _playlists;
        }
       
    }
}
