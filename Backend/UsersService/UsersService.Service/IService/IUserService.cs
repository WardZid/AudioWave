using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using UsersService.Core.DTOs;
using UsersService.Core.Entities;

namespace UsersService.Service.IService
{
    public interface IUserService
    {
        Task<bool> UsernameExists(string username);
        Task<bool> EmailExists(string username);
        Task<bool> RegisterUserAsync(string email, string username, string password, string firstName, string lastName);
        Task<UserEntity?> AuthenticateUserAsync(string email, string password);
    }
}
