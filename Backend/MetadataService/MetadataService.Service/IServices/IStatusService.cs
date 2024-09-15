using MetadataService.Infrastructure.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MetadataService.Service.IServices
{
    public interface IStatusService
    {
        Task<IEnumerable<Status>> GetStatuses();
    }
}
