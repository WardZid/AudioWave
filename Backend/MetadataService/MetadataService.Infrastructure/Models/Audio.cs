using System;
using System.Collections.Generic;
using System.Text.Json.Serialization;

namespace MetadataService.Infrastructure.Models;

public partial class Audio
{
    public int Id { get; set; }

    public string? Title { get; set; }

    public string? Description { get; set; }

    public byte[]? Thumbnail { get; set; }

    public int DurationSec { get; set; }

    public long? FileSize { get; set; }

    public string? FileType { get; set; }

    public byte[]? FileChecksum { get; set; }

    public int? Listens { get; set; }

    public int? StatusId { get; set; }

    public int VisibilityId { get; set; }

    public DateTime? UploadedAt { get; set; }

    public int? UploaderId { get; set; }

    [JsonIgnore]
    public virtual ICollection<Listen> ListensNavigation { get; set; } = new List<Listen>();

    [JsonIgnore]
    public virtual Status? Status { get; set; }

    [JsonIgnore]
    public virtual ICollection<Tag> Tags { get; set; } = new List<Tag>();

    [JsonIgnore]
    public virtual Visibility? Visibility { get; set; }
}
