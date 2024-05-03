Shader "CustomShader/AfterImage"
{
    Properties
    {
        _BaseColor("Base Color", Color) = (1, 1, 1, 1)
        _AfterImageColor("AfterImage Color", Color) = (1, 1, 1, 1)
        _AfterImagePower("After Image Power", Range(0,1)) = 0.5
        _GhostDuration("Ghost Duration", Range(0.1, 2.0)) = 0.5
        _MainTex("Texture", 2D) = "white" {}
        _NoiseTexture("Noise Texture", 2D) = "white" {}
        _GhostTexture("Ghost Texture", 2D) = "white" {}
        _Alpha("Alpha", Range(0,1)) = 0.5
        _NoiseStrength("Noise Strength", Range(0,1)) = 0.2
        _OffsetStrength("Offset Strength", Range(0,0.1)) = 0.01
        _BlurStrength("Blur Strength", Range(0, 0.1)) = 0.02
    }

        SubShader
        {
           Tags {  "ForceNoShadowCasting" = "True""RenderType" = "Transparent""Queue" = "Geometry-500""LightMode" = "UniversalForwardOnly"}
          //  Conservative True
            Pass
            {
                Name "AfterImagePass"
               // Tags {"LightMode" = "UniversalForwardOnly"}
         
                Blend SrcAlpha OneMinusSrcAlpha
                LOD 100
           /*     ZWrite Off
                AlphaTest Off
                ColorMask RGB0*/
                Offset -1,-1
          /*      Stencil
                {
                    Ref 2
                    Comp Always
                    Pass Replace
                }*/
                HLSLPROGRAM
                #pragma vertex vert
                #pragma fragment frag
                #include "Assets/Editor/Packages/Core.hlsl"

                struct Attributes
                {
                    float4 positionOS : POSITION;
                    float3 normalOS : NORMAL;
                    float2 uv : TEXCOORD0;
                };

                struct Varyings
                {
                    float4 positionHCS : SV_POSITION;
                    float3 normalWS : NORMAL;
                    float2 uv : TEXCOORD0;
                    float2 timeOffset: TEXCOORD1;
                };

                float4 _BaseColor;
                float4 _AfterImageColor;
                float _AfterImagePower;
                float _Alpha;
                float _GhostDuration;
                float _NoiseStrength;
                float _OffsetStrength;
                float _BlurStrength;
                TEXTURE2D(_MainTex);
                TEXTURE2D(_NoiseTexture);
                TEXTURE2D(_GhostTexture);
                SAMPLER(sampler_MainTex);
                SAMPLER(sampler_NoiseTexture);
                SAMPLER(sampler_GhostTexture);

                Varyings vert(Attributes IN)
                {
                    Varyings OUT;
                    OUT.positionHCS = TransformObjectToHClip(IN.positionOS.xyz);
                    OUT.normalWS = TransformObjectToWorldNormal(IN.normalOS);
                    float2 offsets = float2 (_SinTime.y,  _CosTime.y) * _OffsetStrength;
                    OUT.uv = saturate(IN.uv + offsets);
                    OUT.timeOffset = sin(_Time.y * _GhostDuration) * _BlurStrength;
                    return OUT;
                }

                float4 frag(Varyings IN) : SV_Target
                {
                    float4 texColor = SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, IN.uv);
                    float4 noiseColor = SAMPLE_TEXTURE2D(_NoiseTexture, sampler_NoiseTexture, IN.uv + IN.timeOffset);
                    float4 ghostColor = SAMPLE_TEXTURE2D(_GhostTexture, sampler_GhostTexture, IN.uv + IN.timeOffset * _GhostDuration);
                    float4 baseColor = texColor * _BaseColor;
                    float4 noiseBlended = lerp(baseColor, noiseColor, _NoiseStrength);
                    float4 finalColor = lerp(noiseBlended, ghostColor, _AfterImagePower);
                    float alphaMask = 1.0 - step(0.3+0.1*_SinTime.y, finalColor.r);
                    finalColor.a *= _Alpha * alphaMask;
                    return finalColor;
                }
                ENDHLSL
            }
        }
            FallBack "Diffuse"
}
