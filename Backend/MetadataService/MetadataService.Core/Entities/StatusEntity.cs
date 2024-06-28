using System;
using System.Collections.Generic;

namespace MetadataService.Core.Enitities;

public partial class StatusEntity
{
    public int Id { get; set; }

    public string Status1 { get; set; } = null!;

    public string? Description { get; set; }

    public virtual ICollection<AudioEntity> Audios { get; set; } = new List<AudioEntity>();
}
