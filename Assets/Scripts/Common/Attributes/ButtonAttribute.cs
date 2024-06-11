#nullable enable

using UnityEngine;

namespace Shaders.Common.Attributes
{
    [System.AttributeUsage(System.AttributeTargets.Field)]
    public class ButtonAttribute : PropertyAttribute
    {
        public readonly string MethodName;

        public ButtonAttribute(string methodName)
        {
            MethodName = methodName;
        }
    }
}