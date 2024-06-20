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
        private static User MapToUserModel(UserEntity userEntity)
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
        private static UserEntity MapToUserEntity(User userModel)
        {
            // Perform mapping from core entity to infrastructure model
            return new UserEntity
            {
                Id = userModel.Id,
                Username = userModel.Username,
                FirstName = userModel.FirstName,
                LastName = userModel.LastName,
                Email = userModel.Email,
                UserSecret = userModel.UserSecret,
                CreatedAt = userModel.CreatedAt,
                UpdatedAt = userModel.UpdatedAt,
            };
        }
        public async Task<bool> RegisterUserAsync(string email, string username, string password, string firstName, string lastName)
        {
            // Check if the username or email already exists
            if (await _userRepository.UsernameExistsAsync(username) || await _userRepository.EmailExistsAsync(email))
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
            using (var pbkdf2 = new Rfc2898DeriveBytes(password, salt, iterations, HashAlgorithmName.SHA256))
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
                    Email = email,
                    Username = username,
                    FirstName = firstName,
                    LastName = lastName,
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

        public async Task<UserEntity?> AuthenticateUserAsync(string email, string password)
        {
            User? user = await _userRepository.GetUserByEmailAsync(email);
            if (user == null)
            {
                //no such user can be found
                return null;
            }
            UserEntity userEntity = MapToUserEntity(user);

            // Extract the stored hash and salt from the stored hashed password
            string storedHashedPassword = userEntity.UserSecret;
            byte[] hashBytes = Convert.FromBase64String(storedHashedPassword);
            byte[] salt = new byte[16];
            Array.Copy(hashBytes, 0, salt, 0, 16);

            // Hash the provided password using the same salt and iterations
            const int iterations = 10000;
            using (var pbkdf2 = new Rfc2898DeriveBytes(password, salt, iterations, HashAlgorithmName.SHA256))
            {
                byte[] hash = pbkdf2.GetBytes(20); // 20 bytes hash output
                byte[] storedHash = new byte[20];
                Array.Copy(hashBytes, 16, storedHash, 0, 20);

                // Compare the hashed passwords
                for (int i = 0; i < 20; i++)
                {
                    if (hash[i] != storedHash[i])
                    {
                        // Passwords do not match
                        return null;
                    }
                }
            }

            // Authentication successful, return the user
            return userEntity;
        }
    }

}
