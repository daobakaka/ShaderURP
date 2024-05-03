Shader "CustomShader/Wrap"
{
    Properties
    {
        _BaseColor("Color", Color) = (1, 1, 1, 1)
        _MainTexture("Texture", 2D) = "white" {}
        _NormalTexture("Normal", 2D) = "gray" {}
        _EmissionColor("Emission", Color) = (0, 0, 0, 1)
        _OutlineColor("Outline Color", Color) = (1, 0, 0, 1)
        _OutlineWidth("Outline Width", Range(0, 1)) = 0.1
        _TestEmissionColor("TestEmissionColor", Color) = (1, 1, 1, 1)
        _WaveAmplitude("Wave Amplitude", Range(0,5)) = 0.1
        _WaveFrequency("Wave Frequency", Range(0,5)) = 0.1
        _WaveSpeed("Wave Speed", Range(0,10)) = 0.1
        _UVThreshold("UVThreshold", Range(0,1)) = 0.1
        _AlphaValue("AlphaValue",Range(0,1))=0.5
    }

        Subshader
        {   Blend SrcAlpha OneMinusSrcAlpha
            BlendOP Add
            Tags {  "Queue" = "Transparent" }
            Pass
            {
                Tags { "RenderType" = "Opaque" "Queue" = "Geometry"}
                LOD 99
                Name "BaseOutline"
                Offset 0.1,-0.1
                HLSLPROGRAM
                #pragma vertex vert
                #pragma fragment frag

                #include "Assets/Editor/Packages/Core.hlsl"
                #include "Assets/Editor/Packages/Lighting.hlsl"

                struct Attributes
                {
                    float4 prePosition : POSITION;
                    float2 uv : TEXCOORD0;
                    float3 preNormal : NORMAL;
                    float3 preTangent : TANGENT;
                };

                struct Varyings
                {
                    float4 chaPosition : SV_POSITION;
                    float2 uv : TEXCOORD0;
                    float3 worldNormal : NORMAL;
                    float3 worldTangent : TANGENT;
                };

                TEXTURE2D(_MainTexture);
                TEXTURE2D(_NormalTexture);
                SAMPLER(sampler_MainTexture);
                SAMPLER(sampler_NormalTexture);
                
                float4 _BaseColor;
                float4 _EmissionColor;

                Varyings vert(Attributes IN)
                {
                    Varyings OUT;
                    OUT.uv = IN.uv;
                    OUT.chaPosition = TransformObjectToHClip(IN.prePosition.xyz);
                    OUT.worldNormal = TransformObjectToWorldNormal(IN.preNormal);
                    OUT.worldTangent = TransformObjectToWorldDir(IN.preTangent);
                    return OUT;
                }

                float4 frag(Varyings IN) : SV_TARGET
                {
                    float4 texColor = SAMPLE_TEXTURE2D(_MainTexture, sampler_MainTexture, IN.uv);
                    return texColor * _BaseColor + _EmissionColor;
                }
                ENDHLSL
            }
            Pass
            {
                Tags {  "Queue" = "Transparent" "LightMode" = "UniversalForwardOnly"}
                LOD 101
                Name "AdvanceOutline"
                    // BlendOp Add
                      //ZWrite Off
                     ZTest Always
                    // ColorMask RGB
                     Offset -0.2,-0.2

                     HLSLPROGRAM
                     #pragma vertex vertOutline
                     #pragma fragment fragOutline

                     #include "Assets/Editor/Packages/Core.hlsl"
                     #include "Assets/Editor/Packages/Lighting.hlsl"

                     struct OutlineAttributes
                     {
                         float4 prePosition : POSITION;
                         float3 preNormal : NORMAL;
                         float2 uv : TEXCOORD1;
                     };

                     struct OutlineVaryings
                     {
                         float4 chaPosition : SV_POSITION;
                         float2 uv : TEXCOORD1;
                     };

                     float4 _OutlineColor;
                     float _OutlineWidth;
                     float4 _TestEmissionColor;
                     float _WaveAmplitude;
                     float _WaveFrequency;
                     float _WaveSpeed;
                     float _UVThreshold;
                     float _AlphaValue;

                     OutlineVaryings vertOutline(OutlineAttributes IN)
                     {
                         OutlineVaryings OUT;
                         float3 worldNormal = normalize(mul((float3x3)UNITY_MATRIX_IT_MV, IN.preNormal));
                         // float3 worldNormal = normalize(mul((float3x3)UNITY_MATRIX_M, IN.preNormal));
                          float3 outlinePosition = IN.prePosition.xyz + worldNormal * _OutlineWidth;
                          float wave = _WaveAmplitude * sin(_WaveFrequency * IN.prePosition.x + _Time.y * _WaveSpeed);
                          float3 positionOffset = float3(wave-0.05, 0, 0);
                          OUT.chaPosition = TransformObjectToHClip(outlinePosition+ positionOffset);
                          OUT.uv = IN.uv;
                          return OUT;
                      }

                     float4 fragOutline(OutlineVaryings IN) : SV_TARGET
                     {
                         _OutlineColor.a = abs(_CosTime.x );
                         _TestEmissionColor.a =abs( _SinTime.y);
                        if (IN.uv.y < _UVThreshold) discard;  // the keyword "discard" could get the method to discard the pixel,also you can add the judging grammar in the fragment chunck
                        return float4(_OutlineColor.rgb, _OutlineColor.a * _AlphaValue);
                      }
                      ENDHLSL
                  }
        }
}
