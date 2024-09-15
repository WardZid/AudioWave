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

    public virtual DbSet<Listen> Listens { get; set; }

    public virtual DbSet<Status> Statuses { get; set; }

    public virtual DbSet<Tag> Tags { get; set; }

    public virtual DbSet<Visibility> Visibilities { get; set; }

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.Entity<Audio>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PK__Audios__3214EC07A4C0E5E1");

            entity.Property(e => e.Description)
                .HasMaxLength(1023)
                .HasDefaultValue("");
            entity.Property(e => e.FileChecksum).HasMaxLength(16);
            entity.Property(e => e.FileType).HasMaxLength(32);
            entity.Property(e => e.Title).HasMaxLength(127);
            entity.Property(e => e.UploadedAt)
                .HasDefaultValueSql("(getdate())")
                .HasColumnType("datetime");

            entity.HasOne(d => d.Status).WithMany(p => p.Audios)
                .HasForeignKey(d => d.StatusId)
                .HasConstraintName("FK__Audios__StatusId__70DDC3D8");

            entity.HasOne(d => d.Visibility).WithMany(p => p.Audios)
                .HasForeignKey(d => d.VisibilityId)
                .HasConstraintName("FK__Audios__Visibili__71D1E811");
        });


        modelBuilder.Entity<Listen>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PK__Listens__3214EC076C1D80BC");

            entity.HasIndex(e => new { e.AudioId, e.UserId }, "UQ_Listens_AudioId_UserId").IsUnique();

            entity.Property(e => e.ListenedAt)
                .HasDefaultValueSql("(getdate())")
                .HasColumnType("datetime");

            entity.HasOne(d => d.Audio).WithMany(p => p.ListensNavigation)
                .HasForeignKey(d => d.AudioId)
                .OnDelete(DeleteBehavior.Cascade)
                .HasConstraintName("FK_Listens_Audios");
        });

        modelBuilder.Entity<Status>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PK__Statuses__3214EC070EB07004");

            entity.HasIndex(e => e.Status1, "UQ__Statuses__3A15923F7C6D44DA").IsUnique();

            entity.Property(e => e.Description)
                .HasMaxLength(255)
                .IsUnicode(false);
            entity.Property(e => e.Status1)
                .HasMaxLength(63)
                .IsUnicode(false)
                .HasColumnName("Status");
        });

        modelBuilder.Entity<Tag>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PK__Tags__3214EC07C8F29416");

            entity.HasIndex(e => new { e.AudioId, e.Tag1 }, "UQ_Tags_AudioId_Tag").IsUnique();

            entity.Property(e => e.Tag1)
                .HasMaxLength(100)
                .HasColumnName("Tag");

            entity.HasOne(d => d.Audio).WithMany(p => p.Tags)
                .HasForeignKey(d => d.AudioId)
                .OnDelete(DeleteBehavior.Cascade)
                .HasConstraintName("FK_Tags_Audios");
        });

        modelBuilder.Entity<Visibility>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PK__Visibili__3214EC075BFF7DF3");

            entity.HasIndex(e => e.Visibility1, "UQ__Visibili__F63D27FF41E1EA2F").IsUnique();

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
