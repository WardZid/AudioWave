using System;
using System.Collections.Generic;
using MetadataService.Infrastructure.Models;
using Microsoft.EntityFrameworkCore;

namespace MetadataService.Infrastructure.Data;

public partial class MetadataDbContext : DbContext
{
    public MetadataDbContext()
    {
    }

    public MetadataDbContext(DbContextOptions<MetadataDbContext> options)
        : base(options)
    {
    }

    public virtual DbSet<Audio> Audios { get; set; }

    public virtual DbSet<Status> Statuses { get; set; }

    public virtual DbSet<Visibility> Visibilities { get; set; }

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.Entity<Audio>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PK__Audios__3214EC07AC41CD37");

            entity.Property(e => e.Description)
                .HasMaxLength(1023)
                .HasDefaultValue("");
            entity.Property(e => e.FileChecksum).HasMaxLength(16);
            entity.Property(e => e.FileType).HasMaxLength(8);
            entity.Property(e => e.Title).HasMaxLength(127);
            entity.Property(e => e.UploadedAt)
                .HasDefaultValueSql("(getdate())")
                .HasColumnType("datetime");

            entity.HasOne(d => d.Status).WithMany(p => p.Audios)
                .HasForeignKey(d => d.StatusId)
                .HasConstraintName("FK__Audios__StatusId__7C4F7684");

            entity.HasOne(d => d.Visibility).WithMany(p => p.Audios)
                .HasForeignKey(d => d.VisibilityId)
                .HasConstraintName("FK__Audios__Visibili__7D439ABD");
        });

        modelBuilder.Entity<Status>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PK__Statuses__3214EC07BDF61ADF");

            entity.HasIndex(e => e.Status1, "UQ__Statuses__3A15923F4BEDB6E3").IsUnique();

            entity.Property(e => e.Description)
                .HasMaxLength(255)
                .IsUnicode(false);
            entity.Property(e => e.Status1)
                .HasMaxLength(63)
                .IsUnicode(false)
                .HasColumnName("Status");
        });

        modelBuilder.Entity<Visibility>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PK__Visibili__3214EC075DE3BB6D");

            entity.HasIndex(e => e.Visibility1, "UQ__Visibili__F63D27FF748B55C1").IsUnique();

            entity.Property(e => e.Description)
                .HasMaxLength(255)
                .IsUnicode(false);
            entity.Property(e => e.Visibility1)
                .HasMaxLength(63)
                .IsUnicode(false)
                .HasColumnName("Visibility");
        });

        OnModelCreatingPartial(modelBuilder);
    }

    partial void OnModelCreatingPartial(ModelBuilder modelBuilder);
}
