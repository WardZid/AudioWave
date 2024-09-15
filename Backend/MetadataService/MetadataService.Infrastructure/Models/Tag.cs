using System;
using System.Collections.Generic;

namespace MetadataService.Infrastructure.Models;

public partial class Tag
{
    public int Id { get; set; }

    public int? AudioId { get; set; }

    public string? Tag1 { get; set; }

    public virtual Audio? Audio { get; set; }
}
