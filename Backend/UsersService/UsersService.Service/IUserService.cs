using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using UsersService.Core.DTOs;

namespace UsersService.Service
{
    public interface IUserService
    {
        Task<bool> UsernameExists(string username);
        Task<bool> EmailExists(string username);
        Task<bool> RegisterUserAsync(UserRegistrationDto dto);
    }
}
