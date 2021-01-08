using System;
using System.Collections;
using System.Collections.Generic;

namespace Shpick.Models
{
    public interface IParameterProvider
    { 
        object GetParameter();
    }

    public enum ParameterControlType
    {
        TextBox, ComboBox, CheckBox
    }

    public interface IParameterSpec
    {
        string Name { get; }
    }

    public class CheckBoxSpec : IParameterSpec
    {
        public CheckBoxSpec(string name)
        {
            Name = name;
        }

        public string Name { get; }
    }

    public class ComboBoxSpec : IParameterSpec
    {
        public ComboBoxSpec(string name)
        {
            Name = name;
        }

        public string Name { get; }
    }

    public class TextBoxSpec : IParameterSpec
    {
        public TextBoxSpec(string name)
        {
            Name = name;
        }

        public string Name { get; }
    }

    public interface IParametersPicker
    {
        IEnumerable<Hashtable> GetParameters();
    }
}