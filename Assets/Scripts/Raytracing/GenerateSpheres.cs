#nullable enable
using Shaders.Common.Attributes;
using UnityEngine;

namespace Raytracing.Raytracing
{
    public sealed class GenerateSpheres : MonoBehaviour
    {
        [SerializeField] private SphereProvider _spherePrefab = null!;

        [SerializeField, Button("Generate")] private bool _generate;

        private void Generate()
        {
            List spheres = new List();

            // Add a number of random spheres
            for (int i = 0; i < SpheresMax; i++)
            {
                Sphere sphere = new Sphere();

                // Radius and radius
                sphere.radius = SphereRadius.x + Random.value * (SphereRadius.y - SphereRadius.x);
                Vector2 randomPos = Random.insideUnitCircle * SpherePlacementRadius;
                sphere.position = new Vector3(randomPos.x, sphere.radius, randomPos.y);

                // Reject spheres that are intersecting others
                foreach (Sphere other in spheres)
                {
                    float minDist = sphere.radius + other.radius;
                    if (Vector3.SqrMagnitude(sphere.position - other.position) < minDist * minDist)
                        goto SkipSphere;
                }

                // Albedo and specular color
                Color color = Random.ColorHSV();
                bool metal = Random.value < 0.5f;
                sphere.albedo = metal ? Vector3.zero : new Vector3(color.r, color.g, color.b);
                sphere.specular = metal ? new Vector3(color.r, color.g, color.b) : Vector3.one * 0.04f;

                // Add the sphere to the list
                spheres.Add(sphere);

                SkipSphere:
                continue;
            }
        }
    }
}