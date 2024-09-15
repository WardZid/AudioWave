﻿using System;
using System.Collections.Generic;

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

    public int? VisibilityId { get; set; }

    public DateTime? UploadedAt { get; set; }

    public int? UploaderId { get; set; }

    public virtual ICollection<Listen> ListensNavigation { get; set; } = new List<Listen>();

    public virtual Status? Status { get; set; }

    public virtual ICollection<Tag> Tags { get; set; } = new List<Tag>();

    public virtual Visibility? Visibility { get; set; }
}
