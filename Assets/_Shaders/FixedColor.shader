Shader "Custom/FixedColor" {
	
	Properties
	{
		_Color ("Main Color", Color) = (1,1,1,1)
		_Rate ("Blend Rate", Range(0.0,1.0)) = 1.0
	}

	SubShader
	{
		Pass{
		CGPROGRAM

		#pragma vertex vert
		#pragma fragment frag

		float4 _Color;
		float _Rate;
	
		struct vertInput
		{
			float4 pos	: POSITION;
			float4 uv	: TEXCOORD0;
			float4 nrm	: NORMAL;
		};

		struct vertOut
		{
			float4 pos	: SV_POSITION;
			float4 uv	: TEXCOORD0;
			float4 nrm	: NORMAL;
		};

		vertOut vert(vertInput input) {
			vertOut o;
			o.pos = mul(UNITY_MATRIX_MVP, input.pos);
			o.uv = input.uv;
			o.nrm = input.nrm;
			return o;
		}

		float4 frag(vertOut input) : COLOR{
			return lerp(_Color, input.nrm, _Rate);
		}

		ENDCG

		}
	}
}
