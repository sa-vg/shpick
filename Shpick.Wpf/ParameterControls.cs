using System;
using System.Windows.Controls;
using Shpick.Models;

namespace Shpick.Wpf
{
    internal interface IControlHolder
    {
        public Control Control { get; }
    }
    
    internal interface IParameterControl: IControlHolder, IParameterProvider
    {
    }

    class TextBoxParameterControl : IParameterControl
    {
        public Control Control => _textBox;
        private readonly TextBox _textBox;
        public TextBoxParameterControl(TextBox textBox)
        {
            _textBox = textBox ?? throw new ArgumentNullException(nameof(textBox));
        }
        
        public object GetParameter()
        {
            return _textBox.Text;
        }
    }

    internal class CheckBoxParameterControl : IParameterControl
    {
        private readonly CheckBox _checkBox;

        public Control Control => _checkBox;

        public CheckBoxParameterControl(CheckBox control)
        {
            _checkBox = control ?? throw new ArgumentNullException(nameof(control));
        }
        
        public object GetParameter()
        {
            return _checkBox.IsChecked;
        }
    }
    
    internal class ComboBoxParameterControl : IParameterControl
    {
        private readonly ComboBox _comboBox;
        public Control Control => _comboBox;
        public ComboBoxParameterControl(ComboBox control)
        {
            _comboBox = control ?? throw new ArgumentNullException(nameof(control));
        }
        
        public object GetParameter()
        {
            return _comboBox.SelectedItem;
        }
    }
}