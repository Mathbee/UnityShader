Shader "Custom/SimpleShader"
{
	Properties{
		_Color ("Main Color", COLOR) = (1,1,1,1)
		_MainTex ("Main Texture", 2D) = "black"{}
	}

	SubShader
	{
		Pass
		{
			CGPROGRAM

			#pragma vertex vert
			#pragma fragment frag
			
			fixed4 _Color;
			//使用一个结构体来定义顶点着色器的输入
			struct a2v {
				//POSITION语义告诉Unity，用模型空间的顶点坐标填充vertex变量
				float4 vertex : POSITION;
				//NORMAL语义告诉Unity，用模型空间的法线方向填充normal变量
				float3 normal : NORMAL;
				//TEXCOORD语义告诉Unity，用模型的第一套纹理坐标填充texcoord
				float4 texcoord : TEXCOORD;
			};

			struct v2f{
				//SV_POSITION语义告诉Unity,pos里包含了定点在裁剪空间中的位置信息
				float4 pos : SV_POSITION; 
				//COLOR0语义可以用于存储颜色信息
				fixed3 color : COLOR0;
			};

			v2f vert (a2v v)
			{
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex); 
				//v.normal包含了顶点的法线方向，其分量范围在[-1.0, 1.0]
				//下面的代码把分量范围映射到了[0.0, 1.0]
				//存储到了o.color中传递给片元着色器
				o.color = v.normal * 0.5 + fixed3(0.5, 0.5, 0.5);
				return o;
			}
			
			fixed4 frag (v2f f) : SV_Target
			{
				fixed3 c = f.color;
				f.color *= _Color.rgb; 
				return fixed4(f.color, 1.0);
			}
			ENDCG
		}
	}
}
