using UnityEngine;
using UnityEditor;

public class NoiseTextureGeneratorEditor : MonoBehaviour
{
    public  int width = 512;
    public  int height=1024;
    public float times = 10;
    [ContextMenu("Genertator An Image Of Nosie")]// 鼠标右键点击
     void GenerateNoiseTexture()
    {
        Texture2D noiseTexture = new Texture2D(width, height); // 创建一个新的Texture2D对象
        for (int y = 0; y < noiseTexture.height; y++)
        {
            for (int x = 0; x < noiseTexture.width; x++)
            {
                float xCoord = (float)x / noiseTexture.width;
                float yCoord = (float)y / noiseTexture.height;
                float sample = Mathf.PerlinNoise(xCoord * times, yCoord * times); // 使用Perlin噪声函数生成值
                noiseTexture.SetPixel(x, y, new Color(sample, sample, sample)); // 设置像素颜色
            }
        }
        noiseTexture.Apply(); // 应用所有像素更改

        // 保存Texture2D对象为一个新的PNG文件
        byte[] bytes = noiseTexture.EncodeToPNG();
        //string path = EditorUtility.SaveFilePanel("Save Texture", "", "NoiseTexture.png", "png");
        string path = "Assets/GenerateResoures/GeneratedNoiseTexture.png";
        if (path.Length != 0)
        {
            System.IO.File.WriteAllBytes(path, bytes);
            AssetDatabase.Refresh(); // 刷新Asset数据库，显示新生成的文件
        }
    }
}

