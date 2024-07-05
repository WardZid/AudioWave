using System;
using System.Collections.Generic;

namespace MetadataService.Core.Models;

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

    public int? StatusId { get; set; }

    public int? VisibilityId { get; set; }

    public int? UploaderId { get; set; }

    public DateTime? UploadedAt { get; set; }

    public virtual Status? Status { get; set; }

    public virtual Visibility? Visibility { get; set; }
}
