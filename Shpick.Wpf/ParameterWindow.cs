using System;
using System.Windows;
using System.Windows.Markup;
using Shpick.Models;

namespace Shpick.Wpf
{
    internal class ParametersWindow
    {
        private readonly Window _window;
        private readonly ControlContainer _container;

        public ParametersWindow(Action onWindowClose)
        {
            _container = new ControlContainer();
            _window = ControlFactory.CreateWindow();
            _window.Content = _container.Container;
            _window.Closed += (_, _) => onWindowClose.Invoke();
        }

        public void AddButton(Action onClickHandler)
        {
            var button = ControlFactory.CreateButton();
            button.Click += (_, _) => onClickHandler.Invoke();
            _container.AddButton(button);
        }

        public void ShowDialog()
        {
            //Debug_ShowMarkup();
            _window.ShowDialog();
        }
        
        public IParameterProvider AddControl(IParameterSpec spec)
        {
            var parameterControl = ParameterControlFactory.Create(spec);
            _container.AddControl(parameterControl.Control);
            return parameterControl;
        }
        
        private void Debug_ShowMarkup()
        {
            var markup = XamlWriter.Save(_window);
            Console.WriteLine(markup);
        }
    }
}