#nullable enable

using System;
using System.Reflection;
using Shaders.Common.Attributes;
using UnityEditor;
using UnityEngine;

namespace Shaders.Editor
{
    [CustomPropertyDrawer(typeof(ButtonAttribute))]
    public class ButtonPropertyDrawer : PropertyDrawer
    {
        private MethodInfo? _eventMethodInfo;

        public override void OnGUI(Rect position, SerializedProperty prop, GUIContent label)
        {
            var inspectorButtonAttribute = (ButtonAttribute)attribute;

            float buttonLength = position.width;
            var buttonRect = new Rect(position.x + (position.width - buttonLength) * 0.5f, position.y, buttonLength,
                                      position.height);

            if (GUI.Button(buttonRect, inspectorButtonAttribute.MethodName))
            {
                Type eventOwnerType = prop.serializedObject.targetObject.GetType();
                string eventName = inspectorButtonAttribute.MethodName;

                if (_eventMethodInfo == null)
                    _eventMethodInfo =
                        eventOwnerType.GetMethod(eventName,
                                                 BindingFlags.Instance | BindingFlags.Static | BindingFlags.Public
                                                 | BindingFlags.NonPublic);

                if (_eventMethodInfo != null)
                    _eventMethodInfo.Invoke(prop.serializedObject.targetObject, null);
                else
                    Debug.LogWarning($"InspectorButton: Unable to find method {eventName} in {eventOwnerType}");
            }
        }
    }
}