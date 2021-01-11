using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using Shpick.Models;

namespace Shpick.Wpf
{
    //TODO: to common with avalonia
    public class ParametersPicker
    {
        private readonly ParameterStream _output;
        private readonly Dictionary<string, IParameterProvider> _parameterProviders = new();

        public ParametersPicker(IParameterSpec[] specs, ParameterStream outputStream)
        {
            if (specs == null) throw new ArgumentNullException(nameof(specs));
            _output = outputStream ?? throw new ArgumentNullException(nameof(outputStream));

            try
            {
                var window = new ParametersWindow(onWindowClose: Close);
                foreach (var parameterSpec in specs)
                {
                    var parameterProvider = window.AddControl(parameterSpec);
                    _parameterProviders.Add(parameterSpec.Name, parameterProvider);
                }
                
                window.AddButton(onClickHandler: PushParameters);
                
                window.ShowDialog();
            }
            catch (Exception e)
            {
                Console.WriteLine(e);
                throw;
            }
        }


        private void Close()
        {
            _output.Close();
        }

        private void PushParameters()
        {
            var parameters = new Hashtable();
            
            foreach (var (name, provider) in _parameterProviders.Select(x=> (x.Key, x.Value))) 
                parameters.Add(name, provider.GetParameter());

            _output.Write(parameters);
        }
    }
}