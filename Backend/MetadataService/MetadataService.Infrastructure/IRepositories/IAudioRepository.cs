using MetadataService.Infrastructure.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using MetadataService.Core.Interfaces;

namespace MetadataService.Infrastructure.IRepositories
{
    public interface IAudioRepository : IRepository<Audio>
    {
        Task AddListenAsync(int audioId);
    }
}
