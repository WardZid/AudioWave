using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AudioWaveBroker
{
    public interface IMessageHandler
    {
        Task HandleMessage(BrokerMessage brokerMessage);
    }
}
