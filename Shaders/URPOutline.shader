Shader "CustomShader/Outline"
{
    Properties
    {
        _BaseColor("Color", Color) = (1, 1, 1, 1)
        _MainTex("Albedo (RGB)", 2D) = "white" {}
        _OutlineColor("Outline Color", Color) = (1, 0, 0, 1)
        _OutlineWidth("Outline Width", Range(0, 1)) = 0.1
    }

        SubShader
        {
            Tags { "RenderType" = "Opaque" }
            LOD 100

            // Outline pass
            Pass
            {
                Name "Outline"
                Tags { "LightMode" = "UniversalForwardOnly" }
                ZWrite On
                ZTest LEqual
               // Cull Front
                Blend SrcAlpha OneMinusSrcAlpha
                ColorMask RGB
                Offset 1, 1

                HLSLPROGRAM
                #pragma vertex vertOutline
                #pragma fragment fragOutline
                #include "Assets/Editor/Packages/Core.hlsl"
                #include "Assets/Editor/Packages/Lighting.hlsl"

                struct Attributes
                {
                    float3 positionOS : POSITION;
                    float3 normalOS : NORMAL;
                };

                struct Varyings
                {
                    float4 positionCS : SV_POSITION;
                };

                float _OutlineWidth;

                Varyings vertOutline(Attributes IN)
                {
                    Varyings OUT;
                    float3 offset = normalize(IN.normalOS) * _OutlineWidth;
                    float4 worldPosition = mul(UNITY_MATRIX_M, float4(IN.positionOS + offset, 1.0));
                    OUT.positionCS = TransformWorldToHClip(worldPosition.xyz);
                    return OUT;
                }

                float4 _OutlineColor;

                float4 fragOutline(Varyings IN) : SV_Target
                {
                    return _OutlineColor;
                }
                ENDHLSL
            }

            // Main pass
            Pass
            {
                Name "MainPass"
               // Tags { "LightMode" = "UniversalForwardOnly" }
                ZWrite On
                ZTest LEqual
                Blend SrcAlpha OneMinusSrcAlpha

                HLSLPROGRAM
                #pragma vertex vert
                #pragma fragment frag
                #include "Assets/Editor/Packages/Core.hlsl"
                #include "Assets/Editor/Packages/Lighting.hlsl"

                struct Attributes
                {
                    float3 positionOS : POSITION;
                    float2 uv : TEXCOORD0;
                };

                struct Varyings
                {
                    float4 positionCS : SV_POSITION;
                    float2 uv : TEXCOORD0;
                };

                TEXTURE2D(_MainTex);
                SAMPLER(sampler_MainTex);

                float4 _BaseColor;

                Varyings vert(Attributes IN)
                {
                    Varyings OUT;
                    OUT.positionCS = TransformObjectToHClip(IN.positionOS);
                    OUT.uv = IN.uv;
                    return OUT;
                }

                float4 frag(Varyings IN) : SV_Target
                {
                    float4 color = SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, IN.uv) * _BaseColor;
                    return color;
                }
                ENDHLSL
            }
        }

            FallBack "Diffuse"
}
