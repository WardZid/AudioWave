using System;
using System.Collections.Generic;

namespace UsersService.Models;

public partial class History
{
    public int UserId { get; set; }

    public int AudioId { get; set; }

    public DateTime? ListenedAt { get; set; }

    public virtual User User { get; set; } = null!;
}
