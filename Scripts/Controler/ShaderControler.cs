using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System.Reflection;
using UnityEngine.Rendering.Universal;
enum ShaderType
{
    Holographic,
    Dissolve,
    Warp,
    Outline,
    FresnelOutline,


}

public class ShaderControler : MonoBehaviour
{
    public ObjectAssets objectAssets;
    [SerializeField]
    private SkinnedMeshRenderer[] _MeshRenders1;
    [SerializeField]
    private SkinnedMeshRenderer[] _meshRenderers2;
    [SerializeField]
    private SkinnedMeshRenderer[] _meshRenderers3;
    [SerializeField]
    private SkinnedMeshRenderer[] _meshRenderers4;
    private MaterialPropertyBlock[] _propertyBlock = new MaterialPropertyBlock[20];
    public bool[] effectsIndex;
    public static ShaderControler INSTANCE;
    private float time;
   
    void Start()
    {
        Ins();
    }
    private void Awake()
    {
        INSTANCE = this;  
    }
    private ShaderControler() { }
    // Update is called once per frame
    void Update()
    {
        // AdujustParameters(ShaderType.Holographic);
        time += Time.deltaTime;
        if (effectsIndex[0])
        ReflectionMode(ShaderType.Holographic);
        if (effectsIndex[1])
        ReflectionMode(ShaderType.Dissolve);
        if (effectsIndex[2])
        ReflectionMode(ShaderType.Warp);
        if (effectsIndex[3])
        ReflectionMode(ShaderType.FresnelOutline);
    }
    void Ins()
    {
       // _propertyBlock = new MaterialPropertyBlock();
    
    
    }

    void ReflectionMode(ShaderType shaderType)
    {
        switch (shaderType)
        {
            case ShaderType.Holographic:
            { Type myType = typeof(ShaderControler);
                Type assetType = typeof(ObjectAssets);
                var myTypeinfo = objectAssets;
                var meshField = assetType.GetField("order", BindingFlags.NonPublic | BindingFlags.Instance);
                var assetMethod = assetType.GetMethod("GetRefernces", BindingFlags.NonPublic | BindingFlags.Instance);
                assetMethod.Invoke(myTypeinfo, new object[] { ShaderType.Holographic });
                var myMethod = myType.GetMethod("AdujustParameters", BindingFlags.NonPublic | BindingFlags.Instance);
                myMethod.Invoke(INSTANCE, new object[] { ShaderType.Holographic });
            }
                break;
            case ShaderType.Dissolve:
            {
                    Type myType = typeof(ShaderControler);
                    var myMethod = myType.GetMethod("AdujustParameters", BindingFlags.NonPublic | BindingFlags.Instance);
                    myMethod.Invoke(INSTANCE, new object[] { ShaderType.Dissolve });
            }
                break;
            case ShaderType.Warp:
                {
                    Type myType = typeof(ShaderControler);
                    var myMethod = myType.GetMethod("AdujustParameters", BindingFlags.NonPublic | BindingFlags.Instance);
                    myMethod.Invoke(INSTANCE, new object[] { ShaderType.Warp});
                }
                break;
            case ShaderType.FresnelOutline:
                {
                    Type myType = typeof(ShaderControler);
                    var myMethod = myType.GetMethod("AdujustParameters", BindingFlags.NonPublic | BindingFlags.Instance);
                    myMethod.Invoke(INSTANCE, new object[] { ShaderType.FresnelOutline });
                }
                break;
        }
    

    }
    void AdujustParameters(ShaderType shader)
    {
        switch (shader)
        {
            case ShaderType.Holographic:
                {
                    if (_propertyBlock[0] == null)
                    { _propertyBlock[0] = new MaterialPropertyBlock(); }
                    foreach (var mesh in _MeshRenders1)
                    {
                        _propertyBlock[0].SetFloat("_DensityFloat", Mathf.Sin(time));
                        mesh.SetPropertyBlock(_propertyBlock[0]);
                    }
                }
                break;
            case ShaderType.Dissolve:
                {
                    if (_propertyBlock[1] == null)
                    { _propertyBlock[1] = new MaterialPropertyBlock(); }
                    foreach (var mesh in _meshRenderers2)
                    {
                        _propertyBlock[1].SetFloat("_DissolveThreshold", Mathf.Sin(time));
                        mesh.SetPropertyBlock(_propertyBlock[1]);
                    }
                }
                break;
            case ShaderType.Warp:
                {
                    if (_propertyBlock[2] == null)
                    { _propertyBlock[2] = new MaterialPropertyBlock(); }
                    foreach (var mesh in _meshRenderers3)
                    {
                        _propertyBlock[2].SetFloat("_OutlineWidth", Mathf.Sin(time));
                        mesh.SetPropertyBlock(_propertyBlock[2]);
                    }
                }
                break;
            case ShaderType.FresnelOutline:
                {
                    if (_propertyBlock[3] == null)
                    { _propertyBlock[3] = new MaterialPropertyBlock(); }
                    foreach (var mesh in _meshRenderers4)
                    {
                        _propertyBlock[3].SetFloat("_FresnelPower", Mathf.Abs(Mathf.Sin(time))*5+1);
                        mesh.SetPropertyBlock(_propertyBlock[3]);
                    }
                }
                break;
        }
    }
}
