using UnityEngine;
using UnityEditor;

public class BlackToTransparent : MonoBehaviour
{
    [MenuItem("Tools/Convert Black Pixels to Transparent")]
    public static void ConvertBlackToTransparent()
    {
        Texture2D texture = Selection.activeObject as Texture2D;
        if (texture == null)
        {
            Debug.LogError("No texture selected or the selected object is not a texture!");
            return;
        }

        // Clone the texture to avoid tampering with the original
        Texture2D newTexture = new Texture2D(texture.width, texture.height, TextureFormat.ARGB32, false);
        newTexture.SetPixels(texture.GetPixels());
        newTexture.Apply();

        Color[] pixels = newTexture.GetPixels();

        for (int i = 0; i < pixels.Length; i++)
        {
            // Check if the color is black
            if (pixels[i].r == 0 && pixels[i].g == 0 && pixels[i].b == 0)
            {
                pixels[i] = new Color(0, 0, 0, 0); // Set to transparent
            }
        }

        newTexture.SetPixels(pixels);
        newTexture.Apply();

        // Save the modified texture
        byte[] bytes = newTexture.EncodeToPNG();
        string path = AssetDatabase.GetAssetPath(texture);
        System.IO.File.WriteAllBytes(path.Replace(".png", "_transparent.png"), bytes);
        AssetDatabase.Refresh();

        Debug.Log("Black pixels converted to transparent. New texture saved as: " + path.Replace(".png", "_transparent.png"));
    }
}
