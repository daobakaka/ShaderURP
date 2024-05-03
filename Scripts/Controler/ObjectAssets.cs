using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[CreateAssetMenu(fileName = "MyData", menuName = "MyGame/MyReflectionData", order = 1)]
public class ObjectAssets : ScriptableObject
{
    private MaterialPropertyBlock _propertyBlock;
    [SerializeField]
    private MeshRenderer[] _meshRenders1;
    [SerializeField]
    private int order = 0;
    void AdujustParameters(ShaderType shader)
    {
        switch (shader)
        {
            case ShaderType.Holographic:
                {
                    if (_propertyBlock == null)
                    { _propertyBlock = new MaterialPropertyBlock(); }
                    foreach (var mesh in _meshRenders1)
                    {

                        _propertyBlock.SetFloat("_DensityFloat", Mathf.Cos(Time.time));
                        mesh.SetPropertyBlock(_propertyBlock);

                    }

                }

                break;
        }

    }
    void GetRefernces(ShaderType shaderType)
    {switch (shaderType)
        {
            case ShaderType.Holographic:
               // Debug.Log($"myRefernces is {order}");
                break;
        
        
        
        
        
        }
    
    
    
    
    
    }
}
