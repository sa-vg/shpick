using System.Windows;
using System.Windows.Controls;
using Shpick.Models;

namespace Shpick.Wpf
{
    internal static class ControlFactory
    {
        public static TextBox CreateTextBox(TextBoxSpec spec) => new()
        {
            Name = spec.Name,
            Height = spec.Height,
        };

        public static ComboBox CreateComboBox(ComboBoxSpec spec) => new()
        {
            Name = spec.Name,
            Height = spec.Height,
            DisplayMemberPath = spec.DisplayMemberPath,
            ItemsSource = spec.ItemsSource
        };

        public static CheckBox CreateCheckBox(CheckBoxSpec spec) => new()
        {
            Name = spec.Name,
            Height = spec.Height,
            VerticalContentAlignment = VerticalAlignment.Center
        };

        public static Window CreateWindow() => new()
        {
            Height = 400,
            Width = 600,
            SizeToContent = SizeToContent.Height,
        };

        public static Button CreateButton() => new()
        {
            Content = "Execute",
            Height = 30,
        };
    }
}