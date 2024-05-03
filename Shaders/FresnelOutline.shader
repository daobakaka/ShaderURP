Shader "CustomShader/FresnelOutline"
{
    Properties
    {
        _BaseColor("Base Color", Color) = (1, 1, 1, 1)
        _FresnelColor("Fresnel Color", Color) = (1, 1, 1, 1)
        _FresnelPower("Fresnel Power", Range(0,10)) = 5
        _MainTex("Texture", 2D) = "white" {}
    }
        SubShader
    {

        Pass
        {
            Name "FresnelOutlinePass"
            Tags { "RenderType" = "Opaque" "RenderPipeline" = "UniversalRenderPipeline" }
            LOD 100
            HLSLPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include"Assets/Editor/Packages/Core.hlsl"
           

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
                float3 viewDirWS : TEXCOORD0;
                float2 uv : TEXCOORD1;
            };

            float4 _BaseColor;
            float4 _FresnelColor;
            float _FresnelPower;
            TEXTURE2D(_MainTex);
            SAMPLER(sampler_MainTex);

            Varyings vert(Attributes IN)
            {
                Varyings OUT;
                OUT.positionHCS = TransformObjectToHClip(IN.positionOS.xyz);
                OUT.normalWS = TransformObjectToWorldNormal(IN.normalOS);
              // OUT.viewDirWS = normalize(_WorldSpaceCameraPos- TransformObjectToWorld(IN.positionOS));
              //  OUT.viewDirWS=normalize(WorldSpaceViewDir(IN.positionOS))
                VertexPositionInputs positions = GetVertexPositionInputs(IN.positionOS.xyz);
                OUT.viewDirWS = normalize(_WorldSpaceCameraPos - positions.positionWS);
                OUT.uv = IN.uv;
                return OUT;
            }

            float4 frag(Varyings IN) : SV_Target
            {
                float cosTheta = dot(normalize(IN.normalWS), normalize(IN.viewDirWS));
                float fresnel = pow(abs(1.0 - cosTheta), _FresnelPower);

                float4 texColor = SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, IN.uv);
                float4 baseColor = texColor * _BaseColor;
                float4 finalColor = lerp(baseColor, _FresnelColor, fresnel);

                return finalColor;
            }
            ENDHLSL
        }
    }
}
