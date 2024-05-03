using UnityEditor;
using UnityEngine;

public class RandomNormalMapGeneratorEditor : EditorWindow
{
    private int width = 256;
    private int height = 256;

    [MenuItem("Tools/Generate Random Normal Map")]
    public static void ShowWindow()
    {
        EditorWindow.GetWindow(typeof(RandomNormalMapGeneratorEditor));
    }

    private void OnGUI()
    {
        GUILayout.Label("Random Normal Map Generator", EditorStyles.boldLabel);

        width = EditorGUILayout.IntField("Width:", width);
        height = EditorGUILayout.IntField("Height:", height);

        if (GUILayout.Button("Generate Normal Map"))
        {
            GenerateRandomNormalMap();
        }
    }

    private void GenerateRandomNormalMap()
    {
        Texture2D normalMapTexture = new Texture2D(width, height, TextureFormat.RGBA32, false);

        for (int y = 0; y < height; y++)
        {
            for (int x = 0; x < width; x++)
            {
                // 生成随机法线向量
                Vector3 randomNormal = new Vector3(Random.value * 2 - 1, Random.value * 2 - 1, Random.value).normalized;

                // 将法线向量转换为纹理颜色
                Color color = new Color((randomNormal.x + 1) * 0.5f, (randomNormal.y + 1) * 0.5f, randomNormal.z, 1f);

                // 设置纹理像素
                normalMapTexture.SetPixel(x, y, color);
            }
        }

        // 应用纹理变化并更新
        normalMapTexture.Apply();

        // 保存纹理到Assets目录下
        string path = EditorUtility.SaveFilePanelInProject("Save Random Normal Map", "RandomNormalMap", "png", "Please enter a file name to save the normal map to");
        if (!string.IsNullOrEmpty(path))
        {
            byte[] bytes = normalMapTexture.EncodeToPNG();
            System.IO.File.WriteAllBytes(path, bytes);
            AssetDatabase.Refresh();

            Debug.Log("Random normal map saved to: " + path);
        }
    }
}
