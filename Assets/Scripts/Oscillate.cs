#nullable enable

using UnityEngine;

namespace Shaders
{
    public sealed class Oscillate : MonoBehaviour
    {
        private Vector3 _originalPosition;

        [SerializeField] private float _speed = 1f;
        [SerializeField] private float _distance = 1f;
        [SerializeField] private Vector3 _direction= Vector3.up;

        private void Awake()
            => _originalPosition = transform.position;

        private void Update()
            => transform.position = _originalPosition + _direction.normalized * (Mathf.Sin(Time.time * _speed) * _distance);
    }
}