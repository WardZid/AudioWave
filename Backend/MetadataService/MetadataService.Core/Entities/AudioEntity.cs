using System;
using System.Collections.Generic;

namespace MetadataService.Core.Enitities;

public partial class AudioEntity
{
    public int Id { get; set; }

    public string? Title { get; set; }

    public string? Description { get; set; }

    public byte[]? Thumbnail { get; set; }

    public int DurationSec { get; set; }

    public long? FileSize { get; set; }

    public string? FileType { get; set; }

    public byte[]? FileChecksum { get; set; }

    public int? StatusId { get; set; }

    public int? VisibilityId { get; set; }

    public int? UploaderId { get; set; }

    public DateTime? UploadedAt { get; set; }

    public virtual StatusEntity? Status { get; set; }

    public virtual VisibilityEntity? Visibility { get; set; }
}
