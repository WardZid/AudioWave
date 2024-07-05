using MetadataService.Core.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MetadataService.Core.DTOs
{
    public class AddAudioDto
    {
        public string? Title { get; set; }

        public string Description { get; set; } = "";

        public byte[]? Thumbnail { get; set; }

        public int DurationSec { get; set; }

        public long? FileSize { get; set; }

        public string? FileType { get; set; }

        public byte[]? FileChecksum { get; set; }

        public int? VisibilityId { get; set; }
    }
}
