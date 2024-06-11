#nullable enable

using System.Collections;
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

        [SerializeField, Button("SaveScreenshot")] private bool _saveScreenshot;

        private IEnumerator SaveScreenshot()
        {
            if (!EditorApplication.isPlaying)
                yield break;

            var texture = new RenderTexture(Screen.width, Screen.height, 24, RenderTextureFormat.ARGB32,
                                            RenderTextureReadWrite.sRGB);
            _camera.targetTexture = texture;

            RenderTexture.active = texture;
            var tex = new Texture2D(texture.width, texture.height, TextureFormat.RGB24, false);
            tex.ReadPixels(new Rect(0, 0, texture.width, texture.height), 0, 0);
            RenderTexture.active = null;

            yield return new WaitForSeconds(_delay);

            byte[] bytes = tex.EncodeToPNG();
            System.IO.File.WriteAllBytes(_fileName, bytes);
            AssetDatabase.ImportAsset(_fileName);
        }
    }
}