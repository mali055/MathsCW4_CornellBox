Shader "Ali/FlatColor" {
	Properties
	{
		_Color("color", Color) = (0.0, 1.0, 0.0, 1.0)
	}

		SubShader{
			Pass{
			CGPROGRAM

			#pragma vertex vert  
			#pragma fragment frag 

			uniform float4 _Color;

		struct vertexInput {
			float4 vertex : POSITION;
			float4 tangent : TANGENT;
			float3 normal : NORMAL;
			float4 texcoord : TEXCOORD0;
			float4 texcoord1 : TEXCOORD1;
			fixed4 color : COLOR;
		};
		struct vertexOutput {
			float4 pos : SV_POSITION;
			float4 col : TEXCOORD0;
		};

		vertexOutput vert(vertexInput input)
		{
			vertexOutput output;

			output.pos = mul(UNITY_MATRIX_MVP, input.vertex);

			return output;
		}

		float4 frag(vertexOutput input) : COLOR
		{
			return _Color;
		}

		ENDCG
	}
	}
}
