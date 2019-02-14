Shader "Custom/WorldRefl" {
	Properties {
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_Cube ("Cubmap", CUBE) = "" {}
		//_BumpMap ("Bumpmap", 2D) = "bump" {}
		//_Detail ("Detail", 2D) = "gray" {}
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
		samplerCUBE _Cube;
		//sampler2D _BumpMap;
		//sampler2D _Detail;
		
		struct Input {
			float2 uv_MainTex;
			float3 worldRefl;
			//float2 uv_BumpMap;
			//float2 uv_Detail;
		};

		// Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
		// See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
		// #pragma instancing_options assumeuniformscaling
		UNITY_INSTANCING_CBUFFER_START(Props)
			// put more per-instance properties here
		UNITY_INSTANCING_CBUFFER_END

		void surf (Input IN, inout SurfaceOutputStandard o) {
			o.Albedo = tex2D(_MainTex, IN.uv_MainTex).rgb;
			o.Emission = texCUBE(_Cube, IN.worldRefl).rgb;
			//o.Albedo *= tex2D(_Detail, IN.uv_Detail).rgb * 2;
			//o.Normal = UnpackNormal(tex2D(_BumpMap, IN.uv_BumpMap));
		}
		ENDCG
	}
	FallBack "Diffuse"
}
