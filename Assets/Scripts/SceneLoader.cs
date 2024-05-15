#nullable enable
using UnityEngine;
using UnityEngine.SceneManagement;

namespace Shaders
{
    public class SceneLoader : MonoBehaviour
    {
        [ContextMenu("Load")]
        private void Load()
        {
            SceneManager.LoadScene(1, LoadSceneMode.Additive);
        }
    }
}
