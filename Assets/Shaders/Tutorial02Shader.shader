Shader "Tutorials/Tutorial_02" //Name of directory that shader can be found
{
	Properties
	{
		//variable name as first parameter which is visible in Inspector, then type as second parameter (textures are 2D)
		_MainTexture("Texture", 2D) = "white"{} //defaults to white if no other textures present
		_Color("Color", Color) = (1,1,1,1) //r,g,b,alpha		
		_AnimationSpeed("Animation Speed", Range(0, 3)) = 0
		_OffsetSize("Offset Size", Range(0, 10)) = 0
	}
	
	SubShader //subshaders alters how the shaders render on varying platforms. They are run on GPU, not CPU
	{
	    //Shaders run code for every pixel on the screen and applies Properties
		//write passes - a part of a shader that gets run. Can be used for different parts of rendering 
		Pass
		{
			CGPROGRAM //Establishes which language we are using and will dictate how objects are rendered

			//pragmas are functions. Must describe which functions
			#pragma vertex vertexFunc //calculates position from screen from mesh of object
			#pragma fragment fragmentFunc //applies color to pixels

			#include "UnityCG.cginc" //including library. cginc is a library for NVidia

			struct appdata
			{
				float4 vertex : POSITION; //float4 is the same as writing four floats ex. (1f,1f,1f,1f)
				float2 uv : TEXCOORD0; //uv figures out how to place texture on object based on coordinates
			};

			struct v2f //vertex to fragment. This will take the position from the screen of the object and convert that information to fragments
			{
				float4 position : SV_POSITION;
				float2 uv : TEXCOORD0;
			};
			
			fixed4 _Color;
			sampler2D _MainTexture;
			float _AnimationSpeed;
			float _OffsetSize;

			v2f vertexFunc(appdata IN) //returns v2f datatype. Takes in appdata input (IN)
			{
				v2f OUT;
				
				IN.vertex.x += sin(_Time.y * _AnimationSpeed + IN.vertex.y * _OffsetSize);
				OUT.position = UnityObjectToClipPos(IN.vertex); //Unity specific command. Takes object position and makes it look right on a perspective camera
				OUT.uv = IN.uv;

				return OUT;
			}

			fixed4 fragmentFunc(v2f IN) : SV_Target //color of the pixel. 4 = RGBA
			{			
				fixed4 pixelColor = tex2D(_MainTexture, IN.uv);

				return pixelColor * _Color;
			}

			ENDCG
		}
	}
}