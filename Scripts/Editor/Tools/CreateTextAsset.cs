using UnityEngine;
using UnityEditor;

public class CreateTextAsset
{
    [MenuItem("Assets/Create/Text File")]
    public static void CreateTextFile()
    {
        var path = AssetDatabase.GetAssetPath(Selection.activeObject);

        if (string.IsNullOrEmpty(path))
        {
            path = "Assets";
        }
        else if (!string.IsNullOrEmpty(AssetDatabase.GetAssetPath(Selection.activeObject)))
        {
            path += "/";
        }

        var fullPath = AssetDatabase.GenerateUniqueAssetPath(path + "New Text.txt");
        System.IO.File.WriteAllText(fullPath, "Hello, World!");
        AssetDatabase.Refresh();
    }
}