﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using UsersService.Core.DTOs;
using UsersService.Infrastructure.Models;

namespace UsersService.Service
{
    public interface ILikeService
    {
        Task<bool> AddLike(int userId, int audioId);
        Task<bool> RemoveLike(int userId, int audioId);
        Task<List<Like>> GetAllLikes(int userId);
    }
}
