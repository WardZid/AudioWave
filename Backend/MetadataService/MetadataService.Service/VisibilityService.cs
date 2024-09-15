using MetadataService.Infrastructure.IRepositories;
using MetadataService.Infrastructure.Models;
using MetadataService.Service.IServices;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MetadataService.Service
{
    public class VisibilityService(
        IVisibilityRepository visibilityRepository
        ) : IVisibilityService
    {
        private readonly IVisibilityRepository _visibilityRepository = visibilityRepository;

        public async Task<IEnumerable<Visibility>> GetVisibilitiesAsync()
        {
            return await _visibilityRepository.GetAllAsync();
        }
    }
}
