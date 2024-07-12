using System;
using System.Collections.Generic;

namespace MetadataService.Infrastructure.Models;

public partial class Visibility
{
    public int Id { get; set; }

    public string Visibility1 { get; set; } = null!;

    public string? Description { get; set; }

    public virtual ICollection<Audio> Audios { get; set; } = new List<Audio>();
}
