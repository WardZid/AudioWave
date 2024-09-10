using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AudioWaveBroker;

public class BrokerMessage
{
    public required string Type { get; set; }
    public required string Content { get; set; }
}
