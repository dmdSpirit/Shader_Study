#nullable enable

using System;
using UnityEngine;

namespace Shaders
{
    [RequireComponent(typeof(MeshRenderer))]
    public sealed class SphereProvider : MonoBehaviour
    {
        private MaterialPropertyBlock? _propertyBlock;
        private MeshRenderer? _renderer;

        private Color _previousColor;
        private Color _previousSpecular;

        [SerializeField] private Color _color;
        [SerializeField] private Color _specular;

        public event Action? OnUpdated;

        private void OnEnable()
            => _renderer = GetComponent<MeshRenderer>();

        private void Update()
        {
            if (!transform.hasChanged
                && _color == _previousColor
                && _specular == _previousSpecular)
                return;
            OnUpdated?.Invoke();
            transform.hasChanged = false;
            _previousColor = _color;
            _previousSpecular = _specular;
        }

        private void OnValidate()
        {
            if (_propertyBlock == null)
                _propertyBlock = new MaterialPropertyBlock();
            if (_renderer == null)
                _renderer = GetComponent<MeshRenderer>();
            _propertyBlock.SetColor("_Color", _color);
            _propertyBlock.SetColor("_SpecColor", _specular);
            _renderer.SetPropertyBlock(_propertyBlock);
        }

        public Sphere GetInfo()
            => new(transform.position, _renderer.bounds.extents.magnitude / 2f,
                   new Vector3(_color.r, _color.g, _color.b), new Vector3(_specular.r, _specular.g, _specular.b));
    }
}