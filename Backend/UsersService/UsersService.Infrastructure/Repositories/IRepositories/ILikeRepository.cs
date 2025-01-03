﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using UsersService.Infrastructure.Models;

namespace UsersService.Infrastructure.Repositories.IRepositories
{
    public interface ILikeRepository
    {
        Task AddLikeAsync(Like like);
        Task DeleteLikeAsync(Like like);
        Task<List<Like>> GetLikesByUserIdAsync(int userId);
    }
}
