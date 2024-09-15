using MetadataService.Infrastructure.Data;
using MetadataService.Infrastructure.IRepositories;
using MetadataService.Infrastructure.Models;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MetadataService.Infrastructure.Repositories;

public class VisibilityRepository(
        MetadataDbContext context
    ) : IVisibilityRepository
{

    private readonly MetadataDbContext _context = context;
    
    public Task<Visibility> AddAsync(Visibility entity)
    {
        throw new NotImplementedException();
    }

    public Task<bool> DeleteAsync(int id, int userId)
    {
        throw new NotImplementedException();
    }

    public async Task<IEnumerable<Visibility>> GetAllAsync()
    {
        return await _context.Visibilities.ToListAsync();
    }

    public async Task<Visibility?> GetByIdAsync(int id)
    {
        return await _context.Visibilities.FindAsync(id);
    }

    public async Task<Visibility> GetByTitleAsync(string title)
    {
        return await _context.Visibilities
                             .FirstOrDefaultAsync(visibility => visibility.Visibility1.ToUpper() == title.ToUpper());
    }

    public Task<Visibility> UpdateAsync(Visibility entity, int userId)
    {
        throw new NotImplementedException();
    }
}
