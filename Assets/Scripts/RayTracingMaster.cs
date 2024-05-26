#nullable enable

using UnityEngine;

namespace Shaders
{
    public class RayTracingMaster : MonoBehaviour
    {
        private RenderTexture _target = null!;
        private Camera _camera = null!;

        [SerializeField]
        private ComputeShader _rayTracingShader = null!;

        [SerializeField]
        private Texture _skybox = null!;

        private void Awake()
            => _camera = GetComponent<Camera>();

        private void OnRenderImage(RenderTexture src, RenderTexture dest)
            => Render(dest);

        private void SetShaderParameters()
        {
            _rayTracingShader.SetMatrix("_CameraToWorld", _camera.cameraToWorldMatrix);
            _rayTracingShader.SetMatrix("_CameraInverseProjection", _camera.projectionMatrix.inverse);
            _rayTracingShader.SetTexture(0, "_SkyboxTexture", _skybox);
        }

        private void Render(RenderTexture destination)
        {
            InitRenderTexture();
            SetShaderParameters();

            _rayTracingShader.SetTexture(0, "Result", _target);
            int threadGroupsX = Mathf.CeilToInt(Screen.width / 8f);
            int threadGroupsY = Mathf.CeilToInt(Screen.height / 8f);
            _rayTracingShader.Dispatch(0, threadGroupsX, threadGroupsY, 1);
            Graphics.Blit(_target, destination);
        }

        private void InitRenderTexture()
        {
            if (_target != null
                && _target.width == Screen.width
                && _target.height == Screen.height)
                return;
            if (_target != null)
                _target.Release();
            _target = new RenderTexture(Screen.width, Screen.height, 0, RenderTextureFormat.ARGBFloat,
                                        RenderTextureReadWrite.Linear);
            _target.enableRandomWrite = true;
            _target.Create();
        }
    }
}