using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using UsersService.Core.DTOs;
using UsersService.Core.Entities;
using UsersService.Infrastructure.Models;
using System.Security.Cryptography;
using Microsoft.EntityFrameworkCore;
using UsersService.Service.IService;
using UsersService.Infrastructure.Repositories.IRepositories;

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

    public async Task<bool> RemoveLike(int userId, int audioId)
    {
        Like newLike = new()
        {
            UserId = userId,
            AudioId = audioId,
            LikedAt = DateTime.Now,
        };

        try
        {
            await _likeRepository.DeleteLikeAsync(newLike);
            return true;
        }
        catch
        {
            return false;
        }
    }

    public async Task<List<Like>> GetAllLikes(int userId)
    {
        return await _likeRepository.GetLikesByUserIdAsync(userId);
    }

    public async Task<bool> IsLiked(int audioId, int userId)
    {
        List<Like> likes = await _likeRepository.GetLikesByUserIdAsync(userId);
        bool isLiked = likes.Where(l => l.AudioId == audioId).Any();

        return isLiked;
    }
}
