Shader"CustomShader/Dissolve"
{
	Properties{
		_BaseColor("Color",Color) = (1,1,1,1)
		_MainTexture("Texture",2D) = "white"{}
		_NormalTexture("Normal",2D) = "gray"{}
		_DissolveTexture("DissolveTexture",2D) = "white"{}
		_NoiseTexture("Nosie",2D) = "gray"{}
		_NoiseStrength("NoiseStrength",Range(0,20)) = 2
		_DissolveThreshold("DissolveThreshold",Range(0,1)) = 0.5
		_EmissionColor("Emission",color) = (0,0,0,1)

	}
		Subshader{
		
			pass {
				Tags{"RenderType" = "Transparent" "Queue" = "Transparent"}
				LOD 100
				Name"Dissolve"
				Offset -1,-1
				Blend SrcAlpha OneMinusSrcAlpha
				HLSLPROGRAM
				#pragma vertex vert
				#pragma fragment frag

				#include"Assets/Editor/Packages/Core.hlsl"
				#include"Assets/Editor/Packages/Lighting.hlsl"
					//#include "UnityCG.cginc"
					struct Attributes {
						float4 prePosition: POSITION;
						float2 uv:TEXCOORD0;
						float3 preNormal:NORMAL;
						float3 preTangent:TANGENT;

					};
					struct Varyings {
						float4 chaPosition:SV_POSITION;
						float2 uv:TEXCOORD0;
						float3 worldNormal:NORMAL;
						float3 worldTangent:TANGENT;

					};
					TEXTURE2D(_MainTexture);
					TEXTURE2D(_NormalTexture);
					TEXTURE2D(_DissolveTexture);
					TEXTURE2D(_NosieTexture);
					SAMPLER(sampler_MainTexture);
					SAMPLER(sampler_NormalTexture);
					SAMPLER(sampler_DissolveTexture);
					SAMPLER(sampler_NosieTexture);

					float4 _BaseColor;
					float4 _EmissionColor;
					float _DissolveThreshold;
					float _LightFloat;
					float4 finalColor;
					float _NoiseStrength;
					// Declare _Time to use the shader's internal time variable
					//float _Time;
					//time is a built in variable in unity shader ,and you do not need to declare it
					Varyings vert(Attributes IN) {
					Varyings OUT;
					// caculate the offsets of the ripple effects
					OUT.uv = IN.uv;
					OUT.chaPosition = TransformObjectToHClip(IN.prePosition.xyz); // change here
					OUT.worldNormal = TransformObjectToWorldNormal(IN.preNormal);
					OUT.worldTangent = TransformObjectToWorldDir(IN.preTangent);
					return OUT;
					}
					float4 frag(Varyings IN) : SV_TARGET{
					float4 texColor = SAMPLE_TEXTURE2D(_MainTexture,sampler_MainTexture,IN.uv );
					float4 texDissolve = SAMPLE_TEXTURE2D(_DissolveTexture,sampler_DissolveTexture,IN.uv);
					finalColor = texColor * _BaseColor + _EmissionColor;
				/*	float alpha = smoothstep(_DissolveThreshold - 0.1, _DissolveThreshold + 0.1, texDissolve.g);
					finalColor.a = alpha;*/
					clip(texDissolve.g - _DissolveThreshold);
					return finalColor;
					}
					ENDHLSL
					}
		}
			Fallback"UnivarsalForward"
}
