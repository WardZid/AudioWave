using System;
using System.Collections.Generic;
using Microsoft.EntityFrameworkCore;
using UsersService.Infrastructure.Models;

namespace UsersService.Infrastructure.Data;

public partial class UsersDbContext : DbContext
{
    public UsersDbContext()
    {
    }

    public UsersDbContext(DbContextOptions<UsersDbContext> options)
        : base(options)
    {
    }

    public virtual DbSet<Follow> Follows { get; set; }

    public virtual DbSet<History> Histories { get; set; }

    public virtual DbSet<Like> Likes { get; set; }

    public virtual DbSet<User> Users { get; set; }

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.Entity<Follow>(entity =>
        {
            entity.HasKey(e => new { e.FollowerId, e.FollowedId }).HasName("PK__Follows__F7A5FC9F118714B3");

            entity.Property(e => e.FollowedAt).HasColumnType("datetime");

            entity.HasOne(d => d.Followed).WithMany(p => p.FollowFolloweds)
                .HasForeignKey(d => d.FollowedId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__Follows__Followe__60A75C0F");

            entity.HasOne(d => d.Follower).WithMany(p => p.FollowFollowers)
                .HasForeignKey(d => d.FollowerId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__Follows__Followe__5FB337D6");
        });

        modelBuilder.Entity<History>(entity =>
        {
            entity.HasKey(e => new { e.UserId, e.AudioId }).HasName("PK__History__0DA06509F89C8D66");

            entity.ToTable("History");

            entity.Property(e => e.ListenedAt).HasColumnType("datetime");

            entity.HasOne(d => d.User).WithMany(p => p.Histories)
                .HasForeignKey(d => d.UserId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__History__UserId__6754599E");
        });

        modelBuilder.Entity<Like>(entity =>
        {
            entity.HasKey(e => new { e.UserId, e.AudioId }).HasName("PK__Likes__0DA06509E8289199");

            entity.Property(e => e.LikedAt).HasColumnType("datetime");

            entity.HasOne(d => d.User).WithMany(p => p.Likes)
                .HasForeignKey(d => d.UserId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__Likes__UserId__6477ECF3");
        });

        modelBuilder.Entity<User>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PK__Users__3214EC073ED07557");

            entity.Property(e => e.CreatedAt).HasColumnType("datetime");
            entity.Property(e => e.Email)
                .HasMaxLength(50)
                .IsUnicode(false);
            entity.Property(e => e.FirstName)
                .HasMaxLength(50)
                .IsUnicode(false);
            entity.Property(e => e.LastName)
                .HasMaxLength(50)
                .IsUnicode(false);
            entity.Property(e => e.UpdatedAt).HasColumnType("datetime");
            entity.Property(e => e.UserSecret)
                .HasMaxLength(50)
                .IsUnicode(false);
            entity.Property(e => e.Username)
                .HasMaxLength(50)
                .IsUnicode(false);
        });

        OnModelCreatingPartial(modelBuilder);
    }

    partial void OnModelCreatingPartial(ModelBuilder modelBuilder);
}
