using System;
using System.Windows.Controls;
using System.Windows.Documents;
using Shpick.Models;

namespace Shpick.Wpf
{
    class TextBoxFactory : IControlFactory<TextBoxSpec> 
    {
        public IParameterControl Create(TextBoxSpec spec)
        {
            var control = new TextBox
            {
                Name = spec.Name,
                Height = 30,
                Width = 250
            };

            return new TextBoxParameterControl(control);
        }
    }
    
    class CheckBoxFactory : IControlFactory<CheckBoxSpec> 
    {
        public IParameterControl Create(CheckBoxSpec spec)
        {
            var control = new CheckBox
            {
                Name = spec.Name,
                Height = 30,
                Width = 250
            };

            return new CheckBoxParameterControl(control);
        }
    }
}