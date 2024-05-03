Shader "CustomShader/Test"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex("InputTex", 2D) = "white" {}
     }

     SubShader
     {
        Pass
        {
            Name "Test"
            Tags { "RenderType" = "Opaque"  "RenderPipeline" = "UniversalRenderPipeline" "Queue" = "Transparent+1" }
       //   Blend SrcAlpha OneMinusSrcAlpha
       // Blend SrcAlpha OneMinusSrcAlpha
         LOD 101
         
            Stencil
         {Ref 1
          Comp Equal
          Pass Keep

     
     }
            HLSLPROGRAM
           #pragma vertex vert
           #pragma fragment frag
           #include"Assets/Editor/Packages/Core.hlsl"

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
                    OUT.position = TransformObjectToHClip(IN.position.xyz );
                    OUT.uv = IN.uv ;

                    return OUT;
                }

                float4 frag(Varyings IN) : SV_Target
                {
                    float4 color = SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, IN.uv) * _Color;
                    return color ;
                }


            ENDHLSL
        }
    }
}
