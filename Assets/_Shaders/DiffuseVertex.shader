Shader "Custom/DiffuseVertex" {
	Properties{
		_Color("Main Color", Color) = (1,1,1,1)
		_Albedo ("Albedo", 2D) = "white" {}
	}
	SubShader{
	Pass{
		Tags{ "LightMode" = "ForwardBase" }

		CGPROGRAM

		#pragma vertex vert
		#pragma fragment frag

		#include "UnityCG.cginc"

		uniform float4 _Color;
		uniform sampler2D _Albedo;
		float2 _Albedo_ST;
		uniform float4 _LightColor0;

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

			//Diffuse/Lambertian Reflectance
			float4 normal = float4(input.nrm, 0);
			float3 n = normalize(mul(normal, _World2Object));
			float3 l = normalize(_WorldSpaceLightPos0);

			float3 NdotL = max(0.0, dot(n, l));
			
			float3 d = NdotL * _LightColor0; //Lambertian Formula

			//ambience
			float3 a = UNITY_LIGHTMODEL_AMBIENT;
			//add texture color
			float4 color = tex * float4 (d+a, 1.0);

			return saturate(color);
		}

		ENDCG
			
	}
	}
}
