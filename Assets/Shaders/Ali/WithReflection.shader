Shader "Ali/WithReflection" {
	Properties
	{
		_Color("Color", Color) = (1.0, 1.0, 1.0, 1.0)
		_SpecColor("Specular", Color) = (1.0, 1.0, 1.0, 1.0)
		_Shininess("Shininess", float) = 10
		_RimColor("RimColor", Color) = (1.0, 1.0, 1.0, 1.0)
		_RimPower("RimPower", Range(0.1, 10.0)) = 3.0
		_Trans("Transparency", Range(0.1, 1.0)) = 0.1
		_Cube("Reflection Cubemap", Cube) = "" {}
	}

	SubShader{
		Tags { "Queue" = "Transparent" }

		//BackPass
		Pass{
			Tags{ "LightMode" = "ForwardBase" }
			Cull Front // first pass renders only back faces
			ZWrite Off // don't write to depth buffer 
					   // in order not to occlude other objects

			Blend SrcAlpha OneMinusSrcAlpha // use alpha blending
			CGPROGRAM

				//pragmas
				#pragma vertex vert  
				#pragma fragment frag 

				#include "UnityCG.cginc"

				//User vars
				uniform float4 _Color;
				uniform float4 _SpecColor;
				uniform float _Shininess;
				uniform float4 _RimColor;
				uniform float _RimPower;
				uniform float _Trans;
				uniform samplerCUBE _Cube;

				//Unity vars
				uniform float4 _LightColor0;

				//structs
				struct vertexInput {
					float4 vertex : POSITION;
					//float4 tangent : TANGENT;
					float3 normal : NORMAL;
					//float4 texcoord : TEXCOORD0;
					//float4 texcoord1 : TEXCOORD1;
					//fixed4 color : COLOR;
				};
				struct vertexOutput {
					float4 pos : SV_POSITION;
					float4 posWorld : TEXCOORD0;
					float3 normalDir : TEXCOORD1;
				};

				//vertex
				vertexOutput vert(vertexInput input)
				{
					vertexOutput output;

					output.posWorld = mul(_Object2World, input.vertex);
					output.normalDir = normalize(mul(float4(input.normal, 0.0), _Object2World).xyz);
					output.pos = mul(UNITY_MATRIX_MVP, input.vertex);

					return output;

				}

				//fragment
				float4 frag(vertexOutput input) : COLOR
				{

					//vectors
					float3 reflectedDir = reflect(input.posWorld, normalize(input.normalDir));
					float3 normalDir = input.normalDir;
					float3 viewDir = normalize(float3(float4(_WorldSpaceCameraPos.xyz, 1.0f) - input.posWorld.xyz));
					float3 lightDir;
					float atten = 1.0f;

					if (_WorldSpaceLightPos0.w == 0.0) { //directional Lights
						atten = 1.0;
						lightDir = normalize(_WorldSpaceLightPos0.rgb);
					}
					else {
						float3 fragmentToLight = _WorldSpaceLightPos0.rgb - input.posWorld.rgb;
						float distance = length(fragmentToLight);
						atten = 1/distance;
						lightDir = normalize(fragmentToLight);
					}
					//lighting
					float3 diffuseRef = atten * _LightColor0.rgb * max(0.0f, dot(normalDir, lightDir));
					float3 specRef = atten * _SpecColor.rgb *  pow(max(0.0, dot(reflect(-lightDir, normalDir),  viewDir)), _Shininess) * max(0.0f, dot(normalDir, lightDir));

					float rim = 1 - dot(normalize(viewDir), normalDir);
					float3 rimLight = atten * _LightColor0.rgb * _RimColor * saturate(dot(normalDir, lightDir)) * pow(rim, _RimPower);
					float3 lighting = rimLight + diffuseRef + specRef + UNITY_LIGHTMODEL_AMBIENT;
					
					return float4(lighting * _Color.rgb, _Trans);
				}

			ENDCG
		}
	
		//FrontPass
		Pass{
			Tags{ "LightMode" = "ForwardAdd" }
			Cull Back // second pass only render front face
			ZWrite Off // don't write to depth buffer 
					   // in order not to occlude other objects

			Blend SrcAlpha OneMinusSrcAlpha // use alpha blending

			CGPROGRAM

				//pragmas
				#pragma vertex vert  
				#pragma fragment frag 
				#include "UnityCG.cginc"

				//User vars
				uniform float4 _Color;
				uniform float4 _SpecColor;
				uniform float _Shininess;
				uniform float4 _RimColor;
				uniform float _RimPower;
				uniform float _Trans;

				//Unity vars
				uniform float4 _LightColor0;

				//structs
				struct vertexInput {
					float4 vertex : POSITION;
					float3 normal : NORMAL;
				};
				struct vertexOutput {
					float4 pos : SV_POSITION;
					float4 posWorld : TEXCOORD0;
					float3 normalDir : TEXCOORD1;
				};

				//vertex
				vertexOutput vert(vertexInput input)
				{
					vertexOutput output;

					output.posWorld = mul(_Object2World, input.vertex);
					output.normalDir = normalize(mul(float4(input.normal, 0.0), _Object2World).xyz);
					output.pos = mul(UNITY_MATRIX_MVP, input.vertex);

					return output;

				}

				//fragment
				float4 frag(vertexOutput input) : COLOR
				{

					//vectors
					float3 normalDir = input.normalDir;
					float3 viewDir = normalize(float3(float4(_WorldSpaceCameraPos.xyz, 1.0f) - input.posWorld.xyz));
					float3 lightDir;
					float atten = 1.0f;

					if (_WorldSpaceLightPos0.w == 0.0) { //directional Lights
						atten = 1.0;
						lightDir = normalize(_WorldSpaceLightPos0.rgb);
					}
					else {
						float3 fragmentToLight = _WorldSpaceLightPos0.rgb - input.posWorld.rgb;
						float distance = length(fragmentToLight);
						atten = 1 / distance;
						lightDir = normalize(fragmentToLight);
					}
					//lighting
					float3 diffuseRef = atten * _LightColor0.rgb * max(0.0f, dot(normalDir, lightDir));
					float3 specRef = atten * _SpecColor.rgb *  pow(max(0.0, dot(reflect(-lightDir, normalDir),  viewDir)), _Shininess) * max(0.0f, dot(normalDir, lightDir));

					float rim = 1 - dot(normalize(viewDir), normalDir);
					float3 rimLight = atten * _LightColor0.rgb * _RimColor * saturate(dot(normalDir, lightDir)) * pow(rim, _RimPower);
					float3 lighting = rimLight + diffuseRef + specRef + UNITY_LIGHTMODEL_AMBIENT;

					return float4(lighting * _Color.rgb, _Trans);
				}

			ENDCG
		}

		//SpecularPass
		Pass{
			Tags{ "LightMode" = "ForwardAdd" }
			ZWrite Off // don't write to depth buffer 
						// in order not to occlude other objects

			Blend One One

			CGPROGRAM

				//pragmas
				#pragma vertex vert  
				#pragma fragment frag 
				#include "UnityCG.cginc"

					//User vars
				uniform float4 _Color;
				uniform float4 _SpecColor;
				uniform float _Shininess;
				uniform float4 _RimColor;
				uniform float _RimPower;
				uniform float _Trans;

				//Unity vars
				uniform float4 _LightColor0;

				//structs
				struct vertexInput {
					float4 vertex : POSITION;
					float3 normal : NORMAL;
				};
				struct vertexOutput {
					float4 pos : SV_POSITION;
					float4 posWorld : TEXCOORD0;
					float3 normalDir : TEXCOORD1;
				};

				//vertex
				vertexOutput vert(vertexInput input)
				{
					vertexOutput output;

					output.posWorld = mul(_Object2World, input.vertex);
					output.normalDir = normalize(mul(float4(input.normal, 0.0), _Object2World).xyz);
					output.pos = mul(UNITY_MATRIX_MVP, input.vertex);

					return output;

				}

				//fragment
				float4 frag(vertexOutput input) : COLOR
				{

					//vectors
					float3 normalDir = input.normalDir;
					float3 viewDir = normalize(float3(float4(_WorldSpaceCameraPos.xyz, 1.0f) - input.posWorld.xyz));
					float3 lightDir;
					float atten = 1.0f;

					if (_WorldSpaceLightPos0.w == 0.0) { //directional Lights
						atten = 1.0;
						lightDir = normalize(_WorldSpaceLightPos0.rgb);
					}
					else {
						float3 fragmentToLight = _WorldSpaceLightPos0.rgb - input.posWorld.rgb;
						float distance = length(fragmentToLight);
						atten = 1 / distance;
						lightDir = normalize(fragmentToLight);
					}
					//lighting
					float3 diffuseRef = atten * _LightColor0.rgb * max(0.0f, dot(normalDir, lightDir));
					float3 specRef = atten * _SpecColor.rgb *  pow(max(0.0, dot(reflect(-lightDir, normalDir),  viewDir)), _Shininess) * max(0.0f, dot(normalDir, lightDir));

					float rim = 1 - dot(normalize(viewDir), normalDir);
					float3 rimLight = atten * _LightColor0.rgb * _RimColor * saturate(dot(normalDir, lightDir)) * pow(rim, _RimPower);
					float3 lighting = rimLight + diffuseRef + specRef;

					return float4(lighting * _Color.rgb, _Trans);
				}

			ENDCG
		}

		//ReflectionPass
		Pass{
			Tags{ "LightMode" = "ForwardAdd" }
			ZWrite Off // don't write to depth buffer 
						// in order not to occlude other objects

			Blend One One

			CGPROGRAM

				//pragmas
				#pragma vertex vert  
				#pragma fragment frag 
				#include "UnityCG.cginc"

				//User vars
				uniform samplerCUBE _Cube;

				//structs
				struct vertexInput {
					float4 vertex : POSITION;
					float3 normal : NORMAL;
				};
				struct vertexOutput {
					float4 pos : SV_POSITION;
					float4 posWorld : TEXCOORD0;
					float3 normalDir : TEXCOORD1;
				};

				//vertex
				vertexOutput vert(vertexInput input)
				{
					vertexOutput output;

					output.posWorld = mul(_Object2World, input.vertex);
					output.normalDir = normalize(mul(float4(input.normal, 0.0), _Object2World).xyz);
					output.pos = mul(UNITY_MATRIX_MVP, input.vertex);

					return output;

				}

				//fragment
				float4 frag(vertexOutput input) : COLOR
				{
					//vectors
					float3 reflectedDir = reflect(input.posWorld, normalize(input.normalDir));
					return texCUBE(_Cube, reflectedDir);
				}

			ENDCG
		}
	}
	// Fallback "Specular"
}
