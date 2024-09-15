using System;
using System.Collections.Generic;

namespace MetadataService.Infrastructure.Models;

public partial class Listen
{
    public int Id { get; set; }

    public int? AudioId { get; set; }

    public int? UserId { get; set; }

    public DateTime? ListenedAt { get; set; }

    public virtual Audio? Audio { get; set; }
}
