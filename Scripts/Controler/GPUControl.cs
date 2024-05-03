using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Rendering;

public class GPUControl : MonoBehaviour
{
    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        
    }

    void SetGlobalParameters()
    {
        var commandBuffer = new CommandBuffer();
        commandBuffer.SetGlobalDepthBias(0.5f, 0.5f);
    
    }
}
