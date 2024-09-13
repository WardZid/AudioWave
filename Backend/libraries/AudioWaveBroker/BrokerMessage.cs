using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AudioWaveBroker;

public class BrokerMessage
{
    public string Type { get; set; } = "";
    public string SerializedContent { get; set; } = "";
}
