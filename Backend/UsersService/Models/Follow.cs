using System;
using System.Collections.Generic;

namespace UsersService.Models;

public partial class Follow
{
    public int FollowerId { get; set; }

    public int FollowedId { get; set; }

    public DateTime? FollowedAt { get; set; }

    public virtual User Followed { get; set; } = null!;

    public virtual User Follower { get; set; } = null!;
}
