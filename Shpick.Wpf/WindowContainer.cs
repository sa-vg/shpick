using System.Windows;
using System.Windows.Controls;

namespace Shpick.Wpf
{
    public class WindowContainer
    {
        public Window Window { get; }
        public Button Button { get; }


        public WindowContainer(Control[] controls)
        {
            var stack = new StackPanel();

            Window = new Window
            {
                Height = 400,
                Width = 600,
                Content = stack
            };

            foreach (var control in controls)
            {
                var line = WrapLine(control);
                stack.Children.Add(line);
            }

            Button = new Button()
            {
                Content = "Execute",
                Height = 30,
                Width = 250
            };
            
            stack.Children.Add(Button);
        }

        private static StackPanel WrapLine(Control control)
        {
            StackPanel line = new()
            {
                Orientation = Orientation.Horizontal
            };

            Label label = new()
            {
                Content = control.Name,
                Height = control.Height,
                Width = 150
            };

            line.Children.Add(label);
            line.Children.Add(control);
            return line;
        }
    }
}