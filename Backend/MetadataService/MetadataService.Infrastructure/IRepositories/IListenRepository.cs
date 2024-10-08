﻿using MetadataService.Core.Interfaces;
using MetadataService.Infrastructure.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MetadataService.Infrastructure.IRepositories
{
    public interface IListenRepository : IRepository<Listen>
    {
        Task<Listen> AddAsync(int audioId, int userId);
    }
}
