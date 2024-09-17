using MongoDB.Bson.Serialization.Attributes;
using MongoDB.Bson;

namespace PlaylistService.API.Models
{
    public enum AccessLevel
    {
        Private,
        Public,
        Unlisted
    }

    public class Playlist
    {
        [BsonId]
        [BsonRepresentation(BsonType.ObjectId)]
        public string Id { get; set; }

        [BsonElement("UserId")]
        public int UserId { get; set; }

        [BsonElement("PlaylistName")]
        public string PlaylistName { get; set; }

        [BsonElement("AudioIds")]
        public HashSet<int> AudioIds { get; set; }

        [BsonElement("CreationDate")]
        public DateTime CreationDate { get; set; }

        [BsonElement("UpdateDate")]
        public DateTime UpdateDate { get; set; }

        [BsonElement("AccessLevel")]
        public AccessLevel AccessLevel { get; set; } = AccessLevel.Private;  // Default to Private
    }
}
