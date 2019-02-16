// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/FalseColor"
{
	Properties {
		_Color ("Color", Color) = (1, 1, 1, 1)
	}

	SubShader {
		Pass {
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"
			
			struct v2f {
				float4 pos : SV_POSITION;
				float4 color : COLOR0;
			};
			
			v2f vert(appdata_full v)
			{
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
				
				//可视化法线方向,法线的每个方向上分量范围为(-1,1)
				o.color = fixed4(v.normal * 0.5 + fixed3(0.5, 0.5, 0.5), 1.0);

				//可视化切线方向,同法线
				o.color *= fixed4(v.tangent * 0.5 + fixed3(0.5, 0.5, 0.5), 1.0);
				//可以直接将颜色赋值为颜色输出，来进行调试
				return o;
			}	

			float4 frag(v2f i) : SV_TARGET
			{
				return i.color;
			}		
			ENDCG
		}
	}
}
