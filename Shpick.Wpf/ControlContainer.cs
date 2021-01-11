using System;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Markup;

namespace Shpick.Wpf
{
    internal class ControlContainer
    {
        public DockPanel Container { get; } = new();

        public void AddControl(Control control)
        {
            var line = WrapLineInDockPanel(control);
            DockPanel.SetDock(line, Dock.Top);
            Container.Children.Add(line);
        }

        public void AddButton(Button button)
        {
            DockPanel.SetDock(button, Dock.Bottom);
            Container.Children.Add(button);
        }
        
        private static UIElement WrapLineInDockPanel(Control control)
        {
            DockPanel line = new()
            {
                LastChildFill = true
            };
            
            Label label = new()
            {
                Content = control.Name,
                Height = control.Height,
                Width = 150
            };
            
            DockPanel.SetDock(label, Dock.Left);
            line.Children.Add(label);
            
            DockPanel.SetDock(control, Dock.Left);
            line.Children.Add(control);
            
            return line;
        }
    }
}