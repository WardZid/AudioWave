using MetadataService.Core.Interfaces;
using MetadataService.Infrastructure.Models;
using Microsoft.EntityFrameworkCore;


namespace MetadataService.Infrastructure.IRepositories
{
    public interface IStatusRepository : IRepository<Status>
    {
        Task<Status> GetStatusByTitleAsync(string title);
    }
}
