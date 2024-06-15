using System;
using System.Collections.Generic;

namespace UsersService.Core.Entities;

public class UserEntity
{
    public int Id { get; set; }

    public string? FirstName { get; set; }

    public string? LastName { get; set; }

    public string Email { get; set; } = null!;

    public string Username { get; set; } = null!;

    public string UserSecret { get; set; } = null!;

    public DateTime? CreatedAt { get; set; }

    public DateTime? UpdatedAt { get; set; }

}
