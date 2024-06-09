#nullable enable

using System;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;

namespace Shaders
{
    public sealed class SceneGeometry : MonoBehaviour
    {
        private readonly List<SphereProvider> _spheres = new();

        public event Action? OnSceneUpdated;
        public ComputeBuffer SpheresBuffer { get; private set; } = null!;

        private void OnEnable()
            => FindSpheres();

        private void FindSpheres()
        {
            _spheres.Clear();
            _spheres.AddRange(FindObjectsOfType<SphereProvider>());
            foreach (SphereProvider sphere in _spheres)
                sphere.OnUpdated += OnSphereUpdated;

            SpheresBuffer = new ComputeBuffer(_spheres.Count, 40);
            SpheresBuffer.SetData(_spheres.Select(s => s.GetInfo()).ToArray());
        }

        private void OnSphereUpdated()
        {
            SpheresBuffer.SetData(_spheres.Select(s => s.GetInfo()).ToArray());
            OnSceneUpdated?.Invoke();
        }

        private void OnDisable()
            => SpheresBuffer?.Dispose();
    }
}