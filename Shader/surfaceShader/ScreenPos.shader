Shader "Custom/ScreenPos" {
	Properties {
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_BumpMap ("Bumpmap", 2D) = "bump" {}
		_Detail ("Detail", 2D) = "gray" {}
		_Amount ("Extrusion Amount", Range(-1,1)) = 0.5
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf Standard fullforwardshadows

		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0

		sampler2D _MainTex;
		sampler2D _BumpMap;
		sampler2D _Detail;
		float _Amount;
		struct Input {
			float2 uv_MainTex;
			float2 uv_BumpMap;
			float2 uv_Detail;
			float4 screenPos;
			float3 worldPos;
			float3 customColor;
		};

		// Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
		// See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
		// #pragma instancing_options assumeuniformscaling
		UNITY_INSTANCING_CBUFFER_START(Props)
			// put more per-instance properties here
		UNITY_INSTANCING_CBUFFER_END

		//顶点着色器
		void vert (inout appdata_full v, out Input o) {
		//	v.vertex.xyz += v.normal * _Amount;
			UNITY_INITIALIZE_OUTPUT(Input,o);
			o.customColor = abs(v.normal);
		}

		void surf (Input IN, inout SurfaceOutputStandard o) {
			//删除像素点用，使部分位置完全透明，不渲染
			//conditionally kill pixel before output
			//clip (frac((IN.worldPos.y+IN.worldPos.z*0.1) * 5) - 0.5);
			
			//普通细节
			//o.Albedo *= tex2D(_Detail, IN.uv_Detail).rgb * 2;
			//o.Normal = UnpackNormal(tex2D(_BumpMap, IN.uv_BumpMap));
			//通过屏幕坐标来贴图
			float2 screenUV = IN.screenPos.xy / IN.screenPos.w;
			screenUV *= float2(8, 6);
			o.Albedo = tex2D(_MainTex, screenUV/* IN.uv_MainTex*/).rgb;
			o.Albedo *= tex2D(_Detail, screenUV).rgb * 2;
			o.Albedo *= IN.customColor;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
