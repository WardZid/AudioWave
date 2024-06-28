using System;
using System.Collections.Generic;

namespace MetadataService.Core.Enitities;

public partial class VisibilityEntity
{
    public int Id { get; set; }

    public string Visibility1 { get; set; } = null!;

    public string? Description { get; set; }

}
