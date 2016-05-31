Shader "Ali/LambertSpecularPixelWithRimLighting" {
	Properties
	{
		_Color("Color", Color) = (1.0, 1.0, 1.0, 1.0)
		_SpecColor("Specular", Color) = (1.0, 1.0, 1.0, 1.0)
		_Shininess("Shininess", float) = 10
		_RimColor("RimColor", Color) = (1.0, 1.0, 1.0, 1.0)
		_RimPower("RimPower", Range(0.1, 10.0)) = 3.0
	}

	SubShader{
		Pass{
			Tags{ "LightMode" = "ForwardBase" }

			CGPROGRAM

				//pragmas
				#pragma vertex vert  
				#pragma fragment frag 

				//User vars
				uniform float4 _Color;
				uniform float4 _SpecColor;
				uniform float _Shininess;
				uniform float4 _RimColor;
				uniform float _RimPower;

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
					float3 normalDir = input.normalDir;
					float3 viewDir = normalize(float3(float4(_WorldSpaceCameraPos.xyz, 1.0f) - input.posWorld.xyz));
					float3 lightDir = normalize(_WorldSpaceLightPos0.xyz);
					float atten = 1.0f;

					//lighting
					float3 diffuseRef = atten * _LightColor0.rgb * max(0.0f, dot(normalDir, lightDir));
					float3 specRef = atten * _SpecColor.rgb *  pow(max(0.0, dot(reflect(-lightDir, normalDir),  viewDir)), _Shininess) * max(0.0f, dot(normalDir, lightDir));
					
					float rim = 1 - dot ( normalize(viewDir), normalDir);
					float3 rimLight = atten * _LightColor0.rgb * _RimColor * saturate(dot(normalDir, lightDir)) * pow ( rim, _RimPower);
					float3 lighting = rimLight + diffuseRef + specRef + UNITY_LIGHTMODEL_AMBIENT;

					return float4(lighting * _Color.rgb, 1.0);
				}

			ENDCG
		}
	}
}
