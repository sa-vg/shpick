using System;
using Shpick.Models;

namespace Shpick.Wpf
{
    internal static class ParameterControlFactory
    {
        public static IParameterControl Create(IParameterSpec spec)
        {
            return spec switch
            {
                TextBoxSpec textBoxSpec => Create(textBoxSpec),
                CheckBoxSpec checkBoxSpec => Create(checkBoxSpec),
                ComboBoxSpec comboBoxSpec => Create(comboBoxSpec),
                _ => throw new ArgumentOutOfRangeException(nameof(spec)),
            };
        }

        private static IParameterControl Create(TextBoxSpec spec)
        {
            var control = ControlFactory.CreateTextBox(spec);
            return new TextBoxParameterControl(control);
        }


        private static IParameterControl Create(ComboBoxSpec spec)
        {
            var control = ControlFactory.CreateComboBox(spec);

            return new ComboBoxParameterControl(control);
        }

        private static IParameterControl Create(CheckBoxSpec spec)
        {
            var control = ControlFactory.CreateCheckBox(spec);

            return new CheckBoxParameterControl(control);
        }
    }
}