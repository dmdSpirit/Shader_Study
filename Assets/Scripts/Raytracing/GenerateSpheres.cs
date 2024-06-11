#nullable enable

using System.Collections.Generic;
using System.Linq;
using JetBrains.Annotations;
using Shaders.Common.Attributes;
using UnityEditor;
using UnityEngine;

namespace Shaders.Raytracing
{
    public sealed class GenerateSpheres : MonoBehaviour
    {
        [SerializeField] private SphereProvider _spherePrefab = null!;
        [SerializeField] private int _numberOfSpheres = 20;
        [SerializeField] private float _minSphereSize = .5f;
        [SerializeField] private float _maxSphereSize = 3f;
        [SerializeField] private Vector2 _spaceCenter;
        [SerializeField] private float _spaceRadius;
        [SerializeField] private float _minY = 0;
        [SerializeField] private float _maxY = 10;
        [SerializeField] private int _maxNumberOfTries = 20;
        [SerializeField] private float _minimalDistance = .5f;
        [SerializeField] private List<SphereProvider> _spheresToSkip = null!;

        [SerializeField, Button("Generate")] private bool _generate;

        [UsedImplicitly]
        private void Generate()
        {
            List<SphereProvider> existingSpheres = GetComponentsInChildren<SphereProvider>(true)
                .Where(s => !_spheresToSkip.Contains(s)).ToList();
            int spheresCount = existingSpheres.Count;
            if (spheresCount > _numberOfSpheres)
                for (int i = spheresCount - 1; i >= _numberOfSpheres; i--)
                {
                    SphereProvider? sphere = existingSpheres[i];
                    existingSpheres.Remove(sphere);
                    DestroyImmediate(sphere.gameObject);
                }
            else if (spheresCount < _numberOfSpheres)
                for (var i = 0; i < _numberOfSpheres - spheresCount; i++)
                {
                    var sphere = PrefabUtility.InstantiatePrefab(_spherePrefab) as SphereProvider;
                    sphere!.transform.SetParent(transform);
                    existingSpheres.Add(sphere);
                }

            for (var index = 0; index < existingSpheres.Count; index++)
            {
                SphereProvider sphere = existingSpheres[index];
                float size = Random.Range(_minSphereSize, _maxSphereSize);
                sphere.transform.localScale = Vector3.one * size;

                Color color = Random.ColorHSV();
                Color spec = Random.ColorHSV();
                
                bool metal = Random.value < 0.8f;
                Vector3 albedo = metal ? Vector3.zero : new Vector3(color.r, color.g, color.b);
                Vector3 specular = metal ? new Vector3(spec.r, spec.g, spec.b) : Vector3.one * 0.04f;
                sphere.SetColors(albedo, specular);

                sphere.transform.position = GeneratePosition(existingSpheres, index);
            }
        }

        private Vector3 GeneratePosition(List<SphereProvider> spheres, int index)
        {
            Vector3 position = Vector3.zero;
            for (var step = 0; step < _maxNumberOfTries; step++)
            {
                float y = Random.Range(_minY, _maxY);
                position = Random.insideUnitSphere * _spaceRadius + new Vector3(_spaceCenter.x, y, _spaceCenter.y);
                if (!HasIntersection(spheres, index, position))
                    return position;
            }

            return position;
        }

        private bool HasIntersection(List<SphereProvider> spheres, int index, Vector3 position)
        {
            for (var i = 0; i < index; i++)
            {
                if (Vector3.Distance(spheres[i].transform.position, position) <= _minimalDistance
                    + spheres[index].transform.localScale.x * 2f + spheres[i].transform.localScale.x * 2f)
                    continue;
                return true;
            }

            return false;
        }
    }
}