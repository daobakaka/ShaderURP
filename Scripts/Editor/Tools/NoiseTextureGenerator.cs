using UnityEngine;
using UnityEditor;

public class NoiseTextureGeneratorEditor : MonoBehaviour
{
    public  int width = 512;
    public  int height=1024;
    public float times = 10;
    [ContextMenu("Genertator An Image Of Nosie")]// ����Ҽ����
     void GenerateNoiseTexture()
    {
        Texture2D noiseTexture = new Texture2D(width, height); // ����һ���µ�Texture2D����
        for (int y = 0; y < noiseTexture.height; y++)
        {
            for (int x = 0; x < noiseTexture.width; x++)
            {
                float xCoord = (float)x / noiseTexture.width;
                float yCoord = (float)y / noiseTexture.height;
                float sample = Mathf.PerlinNoise(xCoord * times, yCoord * times); // ʹ��Perlin������������ֵ
                noiseTexture.SetPixel(x, y, new Color(sample, sample, sample)); // ����������ɫ
            }
        }
        noiseTexture.Apply(); // Ӧ���������ظ���

        // ����Texture2D����Ϊһ���µ�PNG�ļ�
        byte[] bytes = noiseTexture.EncodeToPNG();
        //string path = EditorUtility.SaveFilePanel("Save Texture", "", "NoiseTexture.png", "png");
        string path = "Assets/GenerateResoures/GeneratedNoiseTexture.png";
        if (path.Length != 0)
        {
            System.IO.File.WriteAllBytes(path, bytes);
            AssetDatabase.Refresh(); // ˢ��Asset���ݿ⣬��ʾ�����ɵ��ļ�
        }
    }
}

