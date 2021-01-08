using System;
using System.Windows.Controls;
using Shpick.Models;

namespace Shpick.Wpf
{
    internal static class ParameterProviderFactory 
    {
        public static IParameterControl Create(IParameterSpec spec)
        {
            return spec switch
            {
                TextBoxSpec textBoxSpec => Create(textBoxSpec),
                CheckBoxSpec checkBoxSpec => Create(checkBoxSpec),
                ComboBoxSpec comboBoxSpec => throw new NotImplementedException(),
                _ => throw new ArgumentOutOfRangeException(nameof(spec)),
            };
        }

        private static IParameterControl Create(TextBoxSpec spec)
        {
            var control = new TextBox
            {
                Name = spec.Name,
                Height = 30,
                Width = 250
            };

            return new TextBoxParameterControl(control);
        }

        private static IParameterControl Create(CheckBoxSpec spec)
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