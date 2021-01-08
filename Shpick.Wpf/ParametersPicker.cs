using System;
using System.Collections;
using System.Collections.Concurrent;
using System.Collections.Generic;
using System.Linq;
using System.Windows;
using Shpick.Models;

namespace Shpick.Wpf
{
    public class ParametersPicker : IParametersPicker
    {
        private readonly IParameterSpec[] _parameterSpecs;
        private BlockingCollection<Hashtable> _pickedParameters = new();
        private IParameterControl[] _providers;
        private WindowContainer _window;

        public ParametersPicker(IParameterSpec[] parameterSpecs)
        {
            _parameterSpecs = parameterSpecs;
        }

        public void ShowWindow()
        {
            try
            {
                _providers = _parameterSpecs.Select(ParameterProviderFactory.Create).ToArray();
                var controls = _providers.Select(x => x.Control).ToArray();
                _window = new WindowContainer(controls);
                _window.Button.Click += ButtonOnClick;
                _window.Window.Closed += WindowOnClosed;
                _window.Window.ShowDialog();
            }
            catch (Exception e)
            {
                Console.WriteLine(e);
                throw;
            }
        }

        private void WindowOnClosed(object sender, EventArgs e)
        {
            try
            {
                Console.WriteLine("Closing Window");
                _pickedParameters.CompleteAdding();
                _pickedParameters.Dispose();
            }
            catch (Exception exception)
            {
                Console.WriteLine(exception);
                throw;
            }
        }

        private void ButtonOnClick(object sender, RoutedEventArgs e)
        {
            try
            {
                var parameters = GetParameterSet();
                _pickedParameters.Add(parameters);
            }
            catch (Exception exception)
            {
                Console.WriteLine(exception);
                throw;
            }
        }

        private Hashtable GetParameterSet()
        {
            return new Hashtable(_providers.ToDictionary(x => x.Control.Name, x => x.GetParameter()));
        }


        public IEnumerable<Hashtable> GetParameters()
        {
            try
            {
                return _pickedParameters.GetConsumingEnumerable();
            }
            catch (Exception e)
            {
                Console.WriteLine(e);
                throw;
            }
        }
    }
}