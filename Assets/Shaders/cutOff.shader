Shader "Cg shader using discard" {

//Matrices are not supported as properties (not accesibles from the inspector), but you can still access them from code using setMatrix()
   Properties
   {
   		_Color ("color", Color) = (0.0, 1.0, 0.0, 1.0)
   		_Color2 ("colorBack", Color) = (0.0, 1.0, 0.0, 1.0)   
   }
   
   SubShader {
      Pass {
         Cull Back // turn off triangle culling, alternatives are:
         // Cull Back (or nothing): cull only back faces 
         // Cull Front : cull only front faces
 
         CGPROGRAM 
 
         #pragma vertex vert  
         #pragma fragment frag 
         
         // uniforms corresponding to properties
         uniform float4x4 _hollowWTL;
         float4 _Color;
 
         struct vertexInput {
            float4 vertex : POSITION;
         };
         struct vertexOutput {
            float4 pos : SV_POSITION;
            float4 posInHollowCoords : TEXCOORD1;
         };
 
         vertexOutput vert(vertexInput input) 
         {
            vertexOutput output;
 
            output.pos =  mul(UNITY_MATRIX_MVP, input.vertex);
            output.posInHollowCoords = mul(_hollowWTL, mul(_Object2World, input.vertex)); 
 
            return output;
         }
 
         float4 frag(vertexOutput input) : COLOR 
         {      	 
         	
            if (length(input.posInHollowCoords) < 1.1) 
            {
               discard; // drop the fragment i
            }
            return _Color;
         }
 
         ENDCG  
      }
        Pass {
         Cull Front // turn off triangle culling, alternatives are:
         // Cull Back (or nothing): cull only back faces 
         // Cull Front : cull only front faces
 
         CGPROGRAM 
 
         #pragma vertex vert  
         #pragma fragment frag 
         
         // uniforms corresponding to properties
         uniform float4x4 _hollowWTL;
         float4 _Color2;
 
         struct vertexInput {
            float4 vertex : POSITION;
         };
         struct vertexOutput {
            float4 pos : SV_POSITION;
            float4 posInHollowCoords : TEXCOORD1;
         };
 
         vertexOutput vert(vertexInput input) 
         {
            vertexOutput output;
 
            output.pos =  mul(UNITY_MATRIX_MVP, input.vertex);
            output.posInHollowCoords = mul(_hollowWTL, mul(_Object2World, input.vertex)); 
 
            return output;
         }
 
         float4 frag(vertexOutput input) : COLOR 
         {      	 
         	
            if (length(input.posInHollowCoords) < 1.1) 
            {
               discard; // drop the fragment i
            }
            return _Color2;
         }
 
         ENDCG  
      }
   }
}