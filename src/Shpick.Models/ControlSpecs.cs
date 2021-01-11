using System.Collections;

namespace Shpick.Models
{
    public interface IParameterSpec
    {
        string Name { get; }
    }
    
    public record CheckBoxSpec : IParameterSpec
    {
        public string Name { get; init; }
        public double Height { get; init; } = Default.ControlHeight;
    }

    public record ComboBoxSpec : IParameterSpec
    {
        public string Name { get; init; }
        public IEnumerable ItemsSource { get; init; }
        public string DisplayMemberPath { get; init; }
        public double Height { get; init; } = Default.ControlHeight;
    }
    
    public record TextBoxSpec : IParameterSpec
    {
        public string Name { get; init; }
        public double Height { get; init; } = Default.ControlHeight;
    }
}