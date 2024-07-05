using System;
using System.Collections.Generic;

namespace MetadataService.Core.Models;

public partial class Status
{
    public int Id { get; set; }

    public string Status1 { get; set; } = null!;

    public string? Description { get; set; }

    public virtual ICollection<Audio> Audios { get; set; } = new List<Audio>();
}
