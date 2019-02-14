// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/Chapter5-Step"
{
	Properties
	{
		_Color("Color", Color) = (1,1,1,1)
		_MainTex("Texture", 2D) = "white"{}
		_NormalTex("NORMAL", 2D) = "bump"{}
		_RimColor("RimColor", Color) = (1,1,1,1)
		_RimPow("RimPow", Range(0.5,8.0)) = 3.0
		_Detail("Detail", 2D) = "gray"{}
	}

	SubShader
	{
		Tags {"RenderType"="Opaque"}
		CGPROGRAM
		#pragma surface surf Lambert
		struct Input{
			float4 color : COLOR;
			float2 uv_MainTex;
			float2 uv_BumpMap;
			float3 viewDir;
			float2 uv_Detail;
			INTERNAL_DATA
		};
		sampler2D _NormalTex;
		sampler2D _MainTex;
		sampler2D _Detail;
		float4 _RimColor;
		float _RimPow;


		void surf(Input IN, inout SurfaceOutput o) {
			fixed4 c = tex2D(_MainTex, IN.uv_MainTex) * IN.color;
			o.Albedo = c.rgb;
			o.Albedo *= tex2D(_Detail, IN.uv_Detail).rgb * 2;
			o.Alpha = 1;
			o.Normal = UnpackNormal(tex2D(_NormalTex, IN.uv_BumpMap));
			//b=saturate(a),若a<0,b=0;若a>1,b=1;否则b=a 
			//dot(x, y): 点积，各分量分别相乘 后 相加 
			half rim = 1.0 - saturate(dot (normalize(IN.viewDir), o.Normal));
			//pow(x, y): x的y次方；
			//o.Emission = _RimColor.rgb * pow (rim, _RimPow);
		}
		ENDCG
	}
	FallBack "Disfuse"
}