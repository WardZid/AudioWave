using MetadataService.Core.Interfaces;
using MetadataService.Infrastructure.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MetadataService.Infrastructure.IRepositories
{
    public interface IVisibilityRepository : IRepository<Visibility>
    {
        Task<Visibility> GetByTitleAsync(string title);
    }
}
