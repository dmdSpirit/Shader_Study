#nullable enable

using System.Collections;
using JetBrains.Annotations;
using Shaders.Common.Attributes;
using UnityEditor;
using UnityEngine;

namespace Shaders.Common
{
    public sealed class ScreenshotSaver : MonoBehaviour
    {
        [SerializeField] private Camera _camera = null!;
        [SerializeField] private float _delay = 5f;
        [SerializeField] private string _fileName = "Assets/screen.png";
        [SerializeField] private Vector2Int _size = new(4096, 3072);
        [SerializeField] private MonoBehaviour _triggerable = null!;

        [SerializeField, Button("SaveScreenshot")] private bool _saveScreenshot;

        [UsedImplicitly]
        private void SaveScreenshot()
            => StartCoroutine(Save());

        private IEnumerator Save()
        {
            if (!EditorApplication.isPlaying)
                yield break;

            EditorUtility.DisplayProgressBar("Saving screenshot", "", 0f);

            if (_triggerable is ITriggerable triggerable)
                triggerable.Trigger();
            var texture = new RenderTexture(_size.x, _size.y, 0, RenderTextureFormat.ARGBFloat, RenderTextureReadWrite.Linear);
            texture.enableRandomWrite = true;
            texture.Create();
            _camera.targetTexture = texture;
            _camera.Render();

            RenderTexture.active = texture;
            var tex = new Texture2D(texture.width, texture.height, TextureFormat.RGB24, false);
            var timePassed = 0f;
            while (timePassed <= _delay)
            {
                yield return new WaitForEndOfFrame();
                timePassed += Time.deltaTime;
                _camera.Render();
                tex.ReadPixels(new Rect(0, 0, texture.width, texture.height), 0, 0);
                tex.Apply();
                EditorUtility.DisplayProgressBar("Saving screenshot", "", timePassed / _delay);
            }

            byte[] bytes = tex.EncodeToPNG();
            System.IO.File.WriteAllBytes(_fileName, bytes);
            AssetDatabase.ImportAsset(_fileName);
            RenderTexture.active = null;
            _camera.targetTexture = null;
            EditorUtility.ClearProgressBar();
            if (_triggerable is ITriggerable t)
                t.Trigger();
        }
    }
}