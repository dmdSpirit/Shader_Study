#nullable enable

using UnityEngine;
using Random = UnityEngine.Random;

namespace Shaders
{
    public sealed class RayTracingMaster : MonoBehaviour
    {
        private RenderTexture _target = null!;
        private Camera _camera = null!;

        private float _currentSample;
        private Material _addMaterial = null!;
        private float _lightIntensity;
        private int _previousNumberOfBounces;

        [SerializeField] private SceneGeometry _sceneGeometry = null!;
        [SerializeField] private ComputeShader _rayTracingShader = null!;
        [SerializeField] private Texture _skybox = null!;
        [SerializeField] private Light _light = null!;
        [SerializeField, Range(1, 20)] private int _numberOfBounces = 2;

        private void Awake()
        {
            _camera = GetComponent<Camera>();
            _lightIntensity = _light.intensity;
            _sceneGeometry.OnSceneUpdated += () => _currentSample = 0;
        }

        private void OnRenderImage(RenderTexture _, RenderTexture dest)
            => Render(dest);

        private void Update()
        {
            if (!transform.hasChanged
                && !_light.transform.hasChanged
                && _lightIntensity == _light.intensity
                && _numberOfBounces == _previousNumberOfBounces)
                return;
            _currentSample = 0;
            transform.hasChanged = false;
            _light.transform.hasChanged = false;
            _lightIntensity = _light.intensity;
            _previousNumberOfBounces = _numberOfBounces;
        }

        private void SetShaderParameters()
        {
            _rayTracingShader.SetMatrix("_CameraToWorld", _camera.cameraToWorldMatrix);
            _rayTracingShader.SetMatrix("_CameraInverseProjection", _camera.projectionMatrix.inverse);
            _rayTracingShader.SetTexture(0, "_SkyboxTexture", _skybox);
            _rayTracingShader.SetBuffer(0, "_Spheres", _sceneGeometry.SpheresBuffer);
        }

        private void Render(RenderTexture destination)
        {
            InitRenderTexture();
            SetShaderParameters();

            _rayTracingShader.SetTexture(0, "Result", _target);
            _rayTracingShader.SetVector("_PixelOffset", new Vector2(Random.value, Random.value));
            Vector3 lightDirection = _light.transform.forward;
            _rayTracingShader.SetVector("_DirectionalLight",
                                        new Vector4(lightDirection.x, lightDirection.y, lightDirection.z,
                                                    _light.intensity));
            _rayTracingShader.SetInt("_NumberOfBounces", _numberOfBounces);
            int threadGroupsX = Mathf.CeilToInt(Screen.width / 8f);
            int threadGroupsY = Mathf.CeilToInt(Screen.height / 8f);
            _rayTracingShader.Dispatch(0, threadGroupsX, threadGroupsY, 1);
            if (_addMaterial == null)
                _addMaterial = new Material(Shader.Find("Hidden/AddShader"));
            _addMaterial.SetFloat("_Sample", _currentSample);
            Graphics.Blit(_target, destination, _addMaterial);
            _currentSample++;
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