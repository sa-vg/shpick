using Shpick.Models;

namespace Shpick.Wpf
{
    internal interface IControlFactory<TSpec> where TSpec: IParameterSpec
    
    {
        public IParameterControl Create(TSpec spec);
    }
}