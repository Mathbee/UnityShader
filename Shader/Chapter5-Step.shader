// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/Chapter5-Step"
{
	Properties
	{
		//Color表示颜色,2D表示贴图,Range(a,b)表示a\b之间的float
		_Color("Color", Color) = (1,1,1,1)
		_MainTex("Texture", 2D) = "white"{}
		_NormalTex("NORMAL", 2D) = "bump"{}
		_Detail("Detail", 2D) = "gray"{}
		_RimColor("RimColor", Color) = (1,1,1,1)
		_RimPow("RimPow", Range(0.5,8.0)) = 3.0
		_Gloss("Rim Gloss", Range(0.0, 10.0)) = 0.5
	}

	SubShader
	{
		Tags {"RenderType"="Opaque"}
		CGPROGRAM
		#pragma surface surf Lambert
		//输入结构体
		struct Input{
			float4 color : COLOR;
			float2 uv_MainTex;
			float2 uv_BumpMap;
			
			float3 viewDir;
			float2 uv_Detail;
			//屏幕坐标
			float2 screenPos;
			INTERNAL_DATA
		};
		//贴图定义
		sampler2D _NormalTex;
		sampler2D _MainTex;
		sampler2D _Detail;
		//颜色定义
		float4 _RimColor;
		float _RimPow;
		float _Gloss;
		//表面着色器
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
			//o.Emission为自发光颜色
			o.Emission = _RimColor.rgb * pow (rim, _RimPow);
			
			o.Gloss = _Gloss * c.a;
		}
		//1. Specular
		//可以是高光贴图也可以是高光颜色 
		//2. Gloss
		//默认值为0.5 
		//gloss用来调制亮斑的大小，一般来讲，gloss越大，光斑越细小，gloss越大，光斑分布越广泛 
		ENDCG
	}
	FallBack "Disfuse"
}