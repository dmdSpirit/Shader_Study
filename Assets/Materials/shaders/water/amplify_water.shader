// Made with Amplify Shader Editor v1.9.4
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "amplify_water"
{
	Properties
	{
		_TessValue( "Max Tessellation", Range( 1, 32 ) ) = 32
		_TessMin( "Tess Min Distance", Float ) = 3
		_TessMax( "Tess Max Distance", Float ) = 40
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Geometry+0" }
		Cull Off
		ZWrite On
		ZTest Less
		CGPROGRAM
		#include "UnityPBSLighting.cginc"
		#include "UnityCG.cginc"
		#include "Tessellation.cginc"
		#pragma target 4.6
		#pragma surface surf StandardCustomLighting keepalpha noforwardadd vertex:vertexDataFunc 
		struct Input
		{
			float4 screenPos;
		};

		struct SurfaceOutputCustomLightingCustom
		{
			half3 Albedo;
			half3 Normal;
			half3 Emission;
			half Metallic;
			half Smoothness;
			half Occlusion;
			half Alpha;
			Input SurfInput;
			UnityGIInput GIData;
		};

		UNITY_DECLARE_DEPTH_TEXTURE( _CameraDepthTexture );
		uniform float4 _CameraDepthTexture_TexelSize;
		uniform float _TessValue;
		uniform float _TessMin;
		uniform float _TessMax;

		void vertexDataFunc( inout appdata_full v )
		{
		}

		inline half4 LightingStandardCustomLighting( inout SurfaceOutputCustomLightingCustom s, half3 viewDir, UnityGI gi )
		{
			UnityGIInput data = s.GIData;
			Input i = s.SurfInput;
			half4 c = 0;
			c.rgb = 0;
			c.a = 1;
			return c;
		}

		inline void LightingStandardCustomLighting_GI( inout SurfaceOutputCustomLightingCustom s, UnityGIInput data, inout UnityGI gi )
		{
			s.GIData = data;
		}

		void surf( Input i , inout SurfaceOutputCustomLightingCustom o )
		{
			o.SurfInput = i;
			o.Normal = float3(0,0,1);
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float4 ase_screenPosNorm = ase_screenPos / ase_screenPos.w;
			ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
			float eyeDepth69 = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, ase_screenPosNorm.xy ));
			float3 temp_cast_0 = (eyeDepth69).xxx;
			o.Emission = temp_cast_0 + 1E-5;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=19400
Node;AmplifyShaderEditor.CommentaryNode;19;-2658,-1570;Inherit;False;1060;595;;9;8;10;11;12;13;14;15;16;17;3d uvs;1,1,1,1;0;0
Node;AmplifyShaderEditor.WorldPosInputsNode;8;-2608,-1520;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;10;-2592,-1248;Inherit;False;Property;_Tiling;Tiling;15;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;14;-2480,-1088;Inherit;False;Property;_WaveSpeed;Wave Speed;16;0;Create;True;0;0;0;False;0;False;0.4;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;11;-2320,-1456;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;12;-2320,-1296;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;15;-2272,-1088;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;13;-2032,-1456;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.CommentaryNode;20;-1408,-1568;Inherit;False;1140;448.8718;;6;3;4;6;5;18;7;Normal;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;17;-1840,-1456;Inherit;False;_3duvs;-1;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;4;-1360,-1392;Inherit;False;Property;_NormanPower;Norman Power;9;0;Create;True;0;0;0;False;0;False;1;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldNormalVector;5;-1296,-1296;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.LerpOp;6;-1072,-1344;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;18;-1152,-1520;Inherit;False;17;_3duvs;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SamplerNode;3;-864,-1392;Inherit;True;Property;_Normal_3D;Normal_3D;7;0;Create;True;0;0;0;False;0;False;-1;ae47f044ac0e47646bea1467c06380cd;ae47f044ac0e47646bea1467c06380cd;True;1;False;white;LockedToTexture3D;True;Object;-1;Auto;Texture3D;8;0;SAMPLER3D;;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;66;-2752,-2368;Inherit;False;1396;393.2573;;6;45;44;43;46;48;47;Refraction + UV;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;7;-512,-1392;Inherit;False;_normal;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;45;-2704,-2192;Inherit;False;Property;_Distort;Distort;12;0;Create;True;0;0;0;False;0;False;0.079;0;0;0.2;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;44;-2640,-2304;Inherit;False;7;_normal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.FunctionNode;43;-2320,-2304;Inherit;False;DepthMaskedRefraction;-1;;1;c805f061214177c42bca056464193f81;2,40,0,103,0;2;35;FLOAT3;0,0,0;False;37;FLOAT;0.02;False;1;FLOAT2;38
Node;AmplifyShaderEditor.CommentaryNode;67;-4160,-704;Inherit;False;1792.513;627.4799;;15;50;51;52;53;54;55;57;58;59;60;61;62;63;64;65;Depth Mask;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;47;-1920,-2080;Inherit;False;_refractUV;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;41;-112,-1616;Inherit;False;1540;776.178;;9;22;25;23;27;26;24;28;29;30;Displacement;1,1,1,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;50;-4112,-656;Inherit;False;47;_refractUV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;22;-48,-1552;Inherit;False;17;_3duvs;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.ScreenDepthNode;51;-3856,-624;Inherit;False;0;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SurfaceDepthNode;52;-4048,-464;Inherit;False;0;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;54;-3984,-288;Inherit;False;Property;_Depth;Depth;13;0;Create;True;0;0;0;False;0;False;1;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;42;-3984,-1648;Inherit;False;984.2112;459.287;;6;33;32;35;37;36;38;Albedo;1,1,1,1;0;0
Node;AmplifyShaderEditor.SamplerNode;23;208,-1568;Inherit;True;Property;_Displace_3D;Displace_3D;8;0;Create;True;0;0;0;False;0;False;23;33559f7652cb70149a63aee6d58ebb6d;33559f7652cb70149a63aee6d58ebb6d;True;1;False;white;LockedToTexture3D;False;Object;-1;Auto;Texture3D;8;0;SAMPLER3D;;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;25;-64,-1008;Inherit;False;Property;_WaveHeight;Wave Height;14;0;Create;True;0;0;0;False;0;False;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;53;-3584,-560;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;55;-3600,-288;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;26;304,-1264;Inherit;False;Constant;_Vector0;Vector 0;9;0;Create;True;0;0;0;False;0;False;0,1,0;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RegisterLocalVarNode;24;624,-1440;Inherit;False;_displace;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TFHCRemapNode;27;304,-1056;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;33;-3840,-1360;Inherit;False;Constant;_Float0;Float 0;9;0;Create;True;0;0;0;False;0;False;0.1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;32;-3936,-1600;Inherit;False;Property;_Color;Color;10;0;Create;True;0;0;0;False;0;False;0,0.2980392,0.4117647,1;0,0.2980392,0.4117647,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;57;-3376,-400;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;28;576,-1264;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;35;-3664,-1472;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;37;-3552,-1296;Inherit;False;24;_displace;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;60;-3184,-336;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;29;960,-1568;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;36;-3440,-1568;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;61;-2976,-336;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;30;1184,-1568;Inherit;False;_vertexOffset;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;38;-3232,-1520;Inherit;False;_albedo;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;62;-2800,-288;Inherit;False;_depthMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScreenPosInputsNode;68;-599.5591,647.7581;Float;False;0;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;2;-480,384;Inherit;False;Property;_Smoothness;Smoothness;6;0;Create;True;0;0;0;False;0;False;0.9021739;0.9;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;16;-2032,-1088;Inherit;False;_time;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;21;-394.6719,-4.584778;Inherit;False;7;_normal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;31;-383.3,220.0811;Inherit;False;30;_vertexOffset;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;39;-368,-128;Inherit;False;38;_albedo;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;40;-572.0488,129.5512;Inherit;False;Property;_Metalic;Metalic;11;0;Create;True;0;0;0;False;0;False;0.58;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ScreenColorNode;46;-1872,-2304;Inherit;False;Global;_GrabScreen0;Grab Screen 0;12;0;Create;True;0;0;0;False;0;False;Object;-1;False;False;False;False;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;48;-1600,-2304;Inherit;False;_distortion;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;58;-3152,-544;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;59;-3328,-480;Inherit;False;Constant;_Float3;Float 3;13;0;Create;True;0;0;0;False;0;False;12;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;63;-2944,-496;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;64;-2768,-448;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;65;-2608,-448;Inherit;False;_edgeFoam;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;49;-592,32;Inherit;False;62;_depthMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScreenDepthNode;69;-360.8062,683.5478;Inherit;False;0;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;0,0;Float;False;True;-1;6;ASEMaterialInspector;0;0;Standard;amplify_water;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Off;1;False;;1;False;;False;0;False;;0;False;;False;0;Custom;0.5;True;False;0;True;Transparent;;Geometry;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;True;0;32;3;40;False;0.5;True;0;0;False;;0;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;5;-1;-1;0;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;17;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;16;FLOAT4;0,0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;11;0;8;1
WireConnection;11;1;10;0
WireConnection;12;0;8;3
WireConnection;12;1;10;0
WireConnection;15;0;14;0
WireConnection;13;0;11;0
WireConnection;13;1;12;0
WireConnection;13;2;15;0
WireConnection;17;0;13;0
WireConnection;6;1;4;0
WireConnection;6;2;5;2
WireConnection;3;1;18;0
WireConnection;3;5;6;0
WireConnection;7;0;3;0
WireConnection;43;35;44;0
WireConnection;43;37;45;0
WireConnection;47;0;43;38
WireConnection;51;0;50;0
WireConnection;23;1;22;0
WireConnection;53;0;51;0
WireConnection;53;1;52;0
WireConnection;55;0;54;0
WireConnection;24;0;23;0
WireConnection;27;0;25;0
WireConnection;57;0;53;0
WireConnection;57;1;55;0
WireConnection;28;0;26;0
WireConnection;28;1;27;0
WireConnection;35;0;32;0
WireConnection;35;1;33;0
WireConnection;60;0;57;0
WireConnection;29;0;23;0
WireConnection;29;1;28;0
WireConnection;36;0;32;0
WireConnection;36;1;35;0
WireConnection;36;2;37;0
WireConnection;61;0;60;0
WireConnection;30;0;29;0
WireConnection;38;0;36;0
WireConnection;62;0;61;0
WireConnection;16;0;15;0
WireConnection;46;0;43;38
WireConnection;48;0;46;0
WireConnection;58;0;53;0
WireConnection;58;1;59;0
WireConnection;63;0;58;0
WireConnection;64;0;63;0
WireConnection;65;0;64;0
WireConnection;69;0;68;0
WireConnection;0;0;39;0
WireConnection;0;1;21;0
WireConnection;0;2;49;0
WireConnection;0;3;40;0
WireConnection;0;4;2;0
WireConnection;0;11;31;0
WireConnection;0;15;69;0
ASEEND*/
//CHKSM=7E495DC49CDC48B71A2DCD14AFCA337B0CB6D609