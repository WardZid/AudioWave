using MetadataService.Infrastructure.IRepositories;
using MetadataService.Infrastructure.Models;
using MetadataService.Service.IServices;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MetadataService.Service;

public class StatusService(
    IStatusRepository statusRepository
    ): IStatusService
{
    private readonly IStatusRepository _statusRepository = statusRepository;

    public async Task<IEnumerable<Status>> GetStatuses()
    {
        return await _statusRepository.GetAllAsync();
    }
}
