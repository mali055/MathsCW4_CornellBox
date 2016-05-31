Shader "Ali/LambertAmbient" {
	Properties
	{
		_Color("color", Color) = (1.0, 1.0, 1.0, 1.0)
	}

	SubShader {
		Pass {
			Tags { "LightMode" = "ForwardBase" }

			CGPROGRAM

			//pragmas
			#pragma vertex vert  
			#pragma fragment frag 
			
			//User vars
			uniform float4 _Color;

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
				float4 col : COLOR;
			};

			//vertex
			vertexOutput vert(vertexInput input)
			{
				vertexOutput output;

				float3 normalDir = normalize(mul(float4(input.normal, 0.0), _Object2World).xyz );
				float3 lightDir;
				float atten = 1.0f;

				lightDir = normalize(_WorldSpaceLightPos0.xyz);

				float3 diffuseRef = atten * _LightColor0.xyz * max (0.0f, dot(normalDir, lightDir));
				float3 lighting = diffuseRef + UNITY_LIGHTMODEL_AMBIENT.xyz;

				output.col = float4(lighting * _Color.rgb, 1.0);
				output.pos = mul(UNITY_MATRIX_MVP, input.vertex);
				
				return output;
			}

			//fragment
			float4 frag(vertexOutput input) : COLOR
			{
				return input.col;
			}

			ENDCG
		}
	}
}
