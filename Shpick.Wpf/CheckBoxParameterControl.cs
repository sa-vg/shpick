using System;
using System.Windows.Controls;

namespace Shpick.Wpf
{
    internal interface IParameterControl
    {
        public Control Control { get; }
        public Object GetParameter();
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
    
    class CheckBoxParameterControl : IParameterControl
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
}