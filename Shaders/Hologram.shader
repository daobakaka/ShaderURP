Shader"CustomShader/Hologram"
{
	Properties{
		_BaseColor("Color",Color) = (1,1,1,1)
		_MainTexture("Texture",2D) = "white"{}
		_NormalTexture("Normal",2D) = "gray"{}
		_HoloTexture("HologramTexture",2D) = "white"{}
		_NoiseTexture("Nosie",2D) = "gray"{}
		_NoiseStrength("NoiseStrength",Range(0,20)) = 2
		_DensityFloat("Density",Range(0,1)) = 0.5
		_EmissionColor("Emission",color) = (0.5,0.5,0.5,1)
		_EmissionLight("EmissionLight",color)=(1,1,1,1)
		_LightFloat("LightFloat",Range(0,10)) = 1
		_WaveAmplitude("Wave Amplitude", Range(0,5)) = 0
		_WaveFrequency("Wave Frequency", Range(0,5)) = 0
		_WaveSpeed("Wave Speed", Range(0,10)) = 0

	}
		Subshader{
			Tags{"RenderType"="Opaque""RenderPipeline" = "UniversalRenderPipeline"}
			LOD 100
			pass {
				Name"Hologram"
				Blend SrcAlpha OneMinusSrcAlpha
				BlendOp Add
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
				TEXTURE2D(_HoloTexture);
				TEXTURE2D(_NosieTexture);
				SAMPLER(sampler_MainTexture);
				SAMPLER(sampler_NormalTexture);
				SAMPLER(sampler_HoloTexture);
				SAMPLER(sampler_NosieTexture);

				float4 _BaseColor;
				float4 _EmissionColor;
				float _DensityFloat;
				float _WaveAmplitude;
				float _WaveFrequency;
				float _WaveSpeed;
				float4 _EmissionLight;
				float _LightFloat;
				float4 finalColor;
				float _NoiseStrength;
				// Declare _Time to use the shader's internal time variable
				//float _Time;
				//time is a built in variable in unity shader ,and you do not need to declare it
				Varyings vert(Attributes IN) {
				Varyings OUT;
				// caculate the offsets of the ripple effects
				float wave = _WaveAmplitude * sin(_WaveFrequency * IN.prePosition.x + _Time.y * _WaveSpeed);
				float3 positionOffset = float3(0, wave, 0);
				OUT.uv = IN.uv ;
				OUT.chaPosition = TransformObjectToHClip(IN.prePosition.xyz+ positionOffset.xyz); // change here
				OUT.worldNormal = TransformObjectToWorldNormal(IN.preNormal);
				OUT.worldTangent = TransformObjectToWorldDir(IN.preTangent);
				return OUT;
				}
				float4 frag(Varyings IN) : SV_TARGET{
				float4 noiseOffset = SAMPLE_TEXTURE2D(_NosieTexture, sampler_NosieTexture, IN.uv)* _NoiseStrength*sin(_Time.y);
				float4 texColor = SAMPLE_TEXTURE2D(_MainTexture,sampler_MainTexture,IN.uv+noiseOffset);
				float4 texNoise = SAMPLE_TEXTURE2D(_NosieTexture,sampler_NosieTexture,IN.uv);
				_EmissionColor.g = abs(_SinTime.y);
				finalColor = texColor * _BaseColor  + _EmissionColor + _EmissionLight*texNoise.r +_EmissionLight*_LightFloat*texNoise.r;
				//finalColor = texColor * _BaseColor;
				//float ranNosie = Nosie(0.5);
				//the module of hologram,use IN.chaPosition and set the out value of alpha	
				float isTransparent = abs(sin(IN.chaPosition.y));
				finalColor.a = isTransparent;
				//finalColor.a = sin(_Time.y);
				clip(isTransparent - _DensityFloat);//clip the pixel which less than zero;
				return finalColor;
				}
				ENDHLSL
				}
		}
			Fallback"UnivarsalForward"
}
