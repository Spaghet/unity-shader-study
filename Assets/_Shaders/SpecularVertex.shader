Shader "Custom/SpecularVertex" {
	Properties {
		_Albedo ("Albedo (RGB)", 2D) = "white" {}
		_SpecColor ("Specular Color", Color) = (1,1,1,1)
		_Specular ("Specular", Int) = 1
	}
	SubShader {
		Tags { "LightMode"="ForwardBase" }
		Pass{
		CGPROGRAM

		#pragma vertex vert
		#pragma fragment frag

		#include "UnityCG.cginc"

		uniform sampler2D _Albedo;
		uniform float4 _LightColor0;
		uniform int _Specular;
		uniform float3 _SpecColor;

		struct vertIn
		{
			float4	pos	:	POSITION;
			float3	nrm	:	NORMAL;
			float4	uv	:	TEXCOORD0;
		};

		struct vertOut
		{
			float4 uv		:	TEXCOORD0;
			float3 nrm		:	NORMAL;
			float4 pos		:	SV_POSITION;
		};

		vertOut vert(vertIn input) {
			vertOut o;

			o.pos = mul(UNITY_MATRIX_MVP, input.pos);
			o.uv = input.uv;
			o.nrm = input.nrm;

			return o;
		}

		float4 frag(vertOut input) : COLOR
		{
			//Sample the albedo
			float4 tex = tex2D(_Albedo, input.uv);

			//vector variables

			float4 normal = float4(input.nrm, 0); //normals
			float3 n = normalize(mul(normal, _World2Object)); //normal
			float3 l = normalize(_WorldSpaceLightPos0); //light vector
			float3 v = normalize(_WorldSpaceCameraPos); //camera position

			//Diffuse/Lambertian Reflectance
			float3 NdotL = max(0.0, dot(n, l));
			float3 d = NdotL * _LightColor0; //diffuse light intensity

			//ambience
			float3 a = UNITY_LIGHTMODEL_AMBIENT;
			
			//specular
			float3 r = reflect(-l, n);
			float RdotV = max(0.0, dot(r, v)); // cosine of viewing angle and reflectance angle
			float3 s = _LightColor0 * _SpecColor * pow(RdotV, _Specular);
			
			//add texture color to ambience + diffuse + 
			float4 color = tex * float4 (d + a + s, 1.0);

			return saturate(color);
		}
		ENDCG
		}
	}
}
