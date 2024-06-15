using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using UsersService.Core;
using UsersService.Core.DTOs;
using UsersService.Infrastructure.Repositories;
using UsersService.Infrastructure.Models;
using UsersService.Core.Entities;
using System.Security.Cryptography;

namespace UsersService.Service
{
    public class UserService : IUserService
    {
        private readonly IUserRepository _userRepository;

        public UserService(IUserRepository userRepository)
        {
            _userRepository = userRepository;
        }
        public async Task<bool> UsernameExists(string username)
        {
            return await _userRepository.UsernameExistsAsync(username);
        }
        public async Task<bool> EmailExists(string email)
        {
            return await _userRepository.EmailExistsAsync(email);
        }
        public async Task<bool> RegisterUserAsync(UserRegistrationDto dto)
        {
            // Check if the username or email already exists
            if (await _userRepository.UsernameExistsAsync(dto.Username) || await _userRepository.EmailExistsAsync(dto.Email))
            {
                return false;
            }


            //hash pass
            // Generate a random salt
            byte[] salt = new byte[16];
            using (RandomNumberGenerator rng = RandomNumberGenerator.Create())
            {
                rng.GetBytes(salt);
            }

            // Hash the password using PBKDF2 with 10000 iterations
            const int iterations = 10000;
            using (var pbkdf2 = new Rfc2898DeriveBytes(dto.Password, salt, iterations, HashAlgorithmName.SHA256))
            {
                byte[] hash = pbkdf2.GetBytes(20); // 20 bytes hash output

                // Combine the salt and hash
                byte[] hashBytes = new byte[36];
                Array.Copy(salt, 0, hashBytes, 0, 16);
                Array.Copy(hash, 0, hashBytes, 16, 20);

                // Convert to base64 string
                string hashedPassword = Convert.ToBase64String(hashBytes);

                // Map DTO to entity
                var userEntity = new UserEntity
                {
                    Email = dto.Email,
                    Username = dto.Username,
                    FirstName = dto.FirstName,
                    LastName = dto.LastName,
                    UserSecret = hashedPassword, // Store the hashed password
                    CreatedAt = DateTime.Now,
                    UpdatedAt = DateTime.Now,
                };

                // Add the user to the database (map to infrastructure model)
                var userModel = MapToUserModel(userEntity);
                await _userRepository.AddUserAsync(userModel);

                return true; // Registration successful
            }
        }
        private User MapToUserModel(UserEntity userEntity)
        {
            // Perform mapping from core entity to infrastructure model
            return new User
            {
                Username = userEntity.Username,
                FirstName = userEntity.FirstName,
                LastName = userEntity.LastName,
                Email = userEntity.Email,
                UserSecret = userEntity.UserSecret,
                CreatedAt = userEntity.CreatedAt,
                UpdatedAt = userEntity.UpdatedAt,
            };
        }
    }

}
