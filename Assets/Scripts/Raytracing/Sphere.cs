#nullable enable

using UnityEngine;

namespace Raytracing.Raytracing
{
    public readonly struct Sphere
    {
        public readonly Vector3 Position;
        public readonly float Radius;
        public readonly Vector3 Albedo;
        public readonly Vector3 Specular;

        public Sphere(Vector3 position, float radius, Vector3 albedo, Vector3 specular)
        {
            Position = position;
            Radius = radius;
            Albedo = albedo;
            Specular = specular;
        }
    }
}