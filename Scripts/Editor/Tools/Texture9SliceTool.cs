using UnityEngine;
using UnityEditor;
using System.IO;

public class Texture9SliceTool
{
    [MenuItem("Tools/Slice Texture Into 9-Slice Grid")]
    public static void SliceTextureIntoGrid()
    {
        Texture2D texture = Selection.activeObject as Texture2D;
        if (texture == null)
        {
            Debug.LogError("No texture selected or the selected object is not a texture!");
            return;
        }

        string folderPath = "Assets/Textures/";
        if (!Directory.Exists(folderPath))
        {
            Directory.CreateDirectory(folderPath);
        }

        int sliceWidth = texture.width / 3;
        int sliceHeight = texture.height / 3;

        for (int i = 0; i < 3; i++)
        {
            for (int j = 0; j < 3; j++)
            {
                Texture2D newTexture = new Texture2D(sliceWidth, sliceHeight);
                newTexture.SetPixels(texture.GetPixels(j * sliceWidth, (2 - i) * sliceHeight, sliceWidth, sliceHeight));
                newTexture.Apply();

                byte[] bytes = newTexture.EncodeToPNG();
                string path = folderPath + "texture_slice_" + i + "_" + j + ".png";
                File.WriteAllBytes(path, bytes);
            }
        }

        AssetDatabase.Refresh();
        Debug.Log("9-slice textures saved in " + folderPath);
    }
}
