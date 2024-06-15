using System;
using System.Collections.Generic;

namespace UsersService.Infrastructure.Models;

public partial class Like
{
    public int UserId { get; set; }

    public int AudioId { get; set; }

    public DateTime? LikedAt { get; set; }

    public virtual User User { get; set; } = null!;
}
