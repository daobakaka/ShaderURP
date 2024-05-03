Shader "CustomShader/StencilTest"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
    _Color("Color", Color) = (1,1,1,1)
        
    }
    SubShader
    {
        Pass
        {
       Tags { "RenderType" = "Transparent" "RenderPipeline" = "UniversalRenderPipeline" "Queue" = "Transparent" }
        LOD 100
       ZWrite Off
       Offset -1,-1
       Blend SrcAlpha OneMinusSrcAlpha
              Stencil
                {
                    Ref 1
                    Comp Always
                    Pass Replace
                }
        HLSLPROGRAM
       
                #pragma vertex vert
                #pragma fragment frag
                #include "Assets/Editor/Packages/Core.hlsl"


          struct Attributes
                {
                    float3 position : POSITION;
                    float2 uv : TEXCOORD0;
                };

                struct Varyings
                {
                    float4 position : SV_POSITION;
                    float2 uv : TEXCOORD0;
                };
                float4 _Color;
                TEXTURE2D(_MainTex);
                SAMPLER(sampler_MainTex);
                Varyings vert(Attributes IN)
                {
                    Varyings OUT;
                    OUT.position = TransformObjectToHClip(IN.position.xyz);
     
                    OUT.uv = IN.uv;

                    return OUT;
                }

                float4 frag(Varyings IN) : SV_Target
                {
                    float4 color = _Color;
                    
                    return color;
                }


            ENDHLSL
        }
    }
}
