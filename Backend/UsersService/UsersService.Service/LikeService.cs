using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using UsersService.Core.DTOs;
using UsersService.Core.Entities;
using UsersService.Infrastructure.Repositories;
using UsersService.Infrastructure.Models;
using System.Security.Cryptography;
using Microsoft.EntityFrameworkCore;

namespace UsersService.Service;

public class LikeService(
    ILikeRepository likeRepository
    ) : ILikeService
{
    private readonly ILikeRepository _likeRepository = likeRepository;

    public async Task<bool> AddLike(int userId, int audioId)
    {
        Like newLike = new()
        {
            UserId = userId,
            AudioId = audioId,
            LikedAt = DateTime.Now,
        };

        try
        {
            await _likeRepository.AddLikeAsync(newLike);
            return true;
        }
        catch
        {
            return false;
        }

    }
}
