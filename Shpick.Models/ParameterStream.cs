using System.Collections;
using System.Collections.Concurrent;
using System.Collections.Generic;

namespace Shpick.Models
{
    public class ParameterStream : IEnumerable<Hashtable>
    {
        private readonly BlockingCollection<Hashtable> _stream = new();

        public void Write(Hashtable parameterSet)
        {
            _stream.Add(parameterSet);
        }
        public void Close()
        {
            _stream.CompleteAdding();
        }
        
        public IEnumerator<Hashtable> GetEnumerator() => _stream.GetConsumingEnumerable().GetEnumerator();
        IEnumerator IEnumerable.GetEnumerator() => GetEnumerator();
    }
}