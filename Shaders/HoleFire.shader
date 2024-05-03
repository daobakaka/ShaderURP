Shader "CustomShader/HoleFire"
{
    Properties
    {
        _MainTex("Flame Texture", 2D) = "white" {}
        _ScrollSpeedX("Scroll Speed X", Range(0,1)) = 0.1
        _ScrollSpeedY("Scroll Speed Y", Range(0,1)) = 0.1
        _ScrollStrength("Strength",Range(0,1)) = 0.1
        _Color("Color Tint", Color) = (1, 0.5, 0, 1)
        _EmissionColor("EmissionColor",Color) = (0,0,0,0)


    }

        SubShader
        {
           Tags { "ForceNoShadowCasting" = "False""RenderType" = "Opaque" "Queue" = "Geometry-500"  }

            Pass
            {
                Name "HoleFirePass"
                   Tags {  "Queue" = "Geometry-500"}
            //Cull Off
            //    Conservative True
                LOD 100
                Blend SrcAlpha OneMinusSrcAlpha
              // ZWrite Off
                Offset -1,-1
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

                TEXTURE2D(_MainTex);
                SAMPLER(sampler_MainTex);
                float4 _MainTex_ST;
                float _ScrollSpeedX;
                float _ScrollSpeedY;
                float4 _Color;
                float4 _EmissionColor;
                float _ScrollStrength;

                Varyings vert(Attributes IN)
                {
                    Varyings OUT;
                   // float3 offset = float3(0, _CosTime.y*IN.position.y ,0) * _ScrollStrength;
                    float3 offset = 0;
                    OUT.position = TransformObjectToHClip(IN.position.xyz+offset.xyz);

                    OUT.uv = IN.uv * _MainTex_ST.xy + _MainTex_ST.zw;
                    OUT.uv.x += sin(_Time.y * _ScrollSpeedX);
                    OUT.uv.y += sin(_Time.y * _ScrollSpeedY);
                    return OUT;
                }

                float4 frag(Varyings IN) : SV_Target
                {   
                    float4 color = SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, IN.uv) * _Color;
                    return color * _EmissionColor;
                }
                ENDHLSL
            }
        }

            FallBack "Diffuse"
}
