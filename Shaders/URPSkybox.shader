Shader "CustomShader/URPSkybox"
{
    Properties
    {
        _Cube("CubeMap", Cube) = "white" { }
    }
        SubShader
    
    {
       // Tags{ "Queue" = "Background-500" "RenderType" = "Transparent" }
        Pass
        {
            //"RenderType" = "Opaque"
                          Stencil
                {
                    Ref 1
                    Comp NotEqual
                    Pass Keep
        }
            HLSLPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma multi_compile_fog
            #include"Assets/Editor/Packages/Core.hlsl"

            struct Attributes
            {
                float3 positionOS : POSITION;
            };

            struct Varyings
            {
                float3 uv : TEXCOORD0;
                float4 positionCS : SV_POSITION;
            };

            TEXTURECUBE(_Cube);
            SAMPLER(sampler_Cube);

            Varyings vert(Attributes IN)
            {
                Varyings OUT;
                OUT.positionCS = TransformObjectToHClip(IN.positionOS.xyz);
                OUT.uv = IN.positionOS;
                return OUT;
            }

           // half4 frag(Varyings IN, out float deepth : SV_Depth) : SV_Target
                half4 frag(Varyings IN) : SV_Target
            {

             //   deepth = 0.99;
                half4 col = SAMPLE_TEXTURECUBE(_Cube, sampler_Cube, IN.uv);
               // UNITY_APPLY_FOG(IN.fogCoord, col); // Apply fog if enabled and configured
                return col;
            }
            ENDHLSL
        }
    }
        Fallback "Diffuse"
}
