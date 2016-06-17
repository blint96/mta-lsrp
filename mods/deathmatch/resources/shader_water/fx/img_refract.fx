//
// file: img_refract.fx
// author: Ren712
//

//---------------------------------------------------------------------
// Variables
//---------------------------------------------------------------------
float3 sElementPosition = float3(0,0,0);
float3 sElementRotation = float3(0,0,0);
float2 sScrSize = float2(800,600);
float sCameraRoll = 0;
float2 sElementSize = float2(1,1);
float2 sElementLow = float2(1,1);

float sFov = 0;
int fFogEnable = 0;
float gAlpha = 1;
float3 gNormalStrength = float3(0.05,0.05,0.05);

bool bIsDetailed = true; 

//---------------------------------------------------------------------
// Include some common stuff
//---------------------------------------------------------------------
float4x4 gWorld : WORLD;
float4x4 gView : VIEW;
float4x4 gProjection : PROJECTION;
float4x4 gViewProjection : VIEWPROJECTION;
float4x4 gWorldViewProjection : WORLDVIEWPROJECTION;
float4x4 gViewInverse : VIEWINVERSE;
texture gDepthBuffer : DEPTHBUFFER;
float4x4 gProjectionMainScene : PROJECTION_MAIN_SCENE;
float4x4 gViewMainScene : VIEW_MAIN_SCENE;
float3 gCameraPosition : CAMERAPOSITION;
float3 gCameraRotation : CAMERAROTATION;
int CUSTOMFLAGS <string skipUnusedParameters = "yes"; >;
int gFogEnable < string renderState="FOGENABLE"; >;
float4 gFogColor < string renderState="FOGCOLOR"; >;
float gFogStart < string renderState="FOGSTART"; >;
float gFogEnd < string renderState="FOGEND"; >;
float gTime : TIME;

//--------------------------------------------------------------------------------------
// Textures
//--------------------------------------------------------------------------------------
texture sProjectiveTexture;
texture sRandomTexture;

//--------------------------------------------------------------------------------------
// Sampler Inputs
//--------------------------------------------------------------------------------------
sampler2D ProjectiveSampler = sampler_state
{
    Texture = (sProjectiveTexture);
    MinFilter = Linear;
    MagFilter = Linear;
    MipFilter = Linear;
    AddressU = Mirror;
    AddressV = Mirror;
};

sampler SamplerDepth = sampler_state
{
    Texture = (gDepthBuffer);
    MinFilter = Point;
    MagFilter = Point;
    MipFilter = None;
    AddressU = Clamp;
    AddressV = Clamp;
};

sampler2D RandomSampler = sampler_state
{
    Texture = (sRandomTexture);
    MinFilter = Linear;
    MagFilter = Linear;
    MipFilter = Linear;
    AddressU = Wrap;
    AddressV = Wrap;
};

//--------------------------------------------------------------------------------------
// Structures
//--------------------------------------------------------------------------------------
struct VSInput
{
    float3 Position : POSITION0;
    float2 TexCoord : TEXCOORD0;
};

struct PSInput
{
    float4 Position : POSITION0;
    float2 TexCoord : TEXCOORD0;
    float DistFromCam : TEXCOORD1;
    float3 TexCoordProj : TEXCOORD2;
    float4 SparkleTex : TEXCOORD3; 
    float3 WorldPos : TEXCOORD4;
    float3 CameraPosition : TEXCOORD5; 	
};

//-----------------------------------------------------------------------------
// Get value from the depth buffer
// Uses define set at compile time to handle RAWZ special case (which will use up a few more slots)
//-----------------------------------------------------------------------------
float FetchDepthBufferValue( float2 uv )
{
    float4 texel = tex2D(SamplerDepth, uv);
#if IS_DEPTHBUFFER_RAWZ
    float3 rawval = floor(255.0 * texel.arg + 0.5);
    float3 valueScaler = float3(0.996093809371817670572857294849, 0.0038909914428586627756752238080039, 1.5199185323666651467481343000015e-5);
    return dot(rawval, valueScaler / 255.0);
#else
    return texel.r;
#endif
}
 
//-----------------------------------------------------------------------------
// Use the last scene projecion matrix to linearize the depth value a bit more
//-----------------------------------------------------------------------------
float Linearize(float posZ)
{
    return gProjectionMainScene[3][2] / (posZ - gProjectionMainScene[2][2]);
}

//-----------------------------------------------------------------------------
// Create world matrix with world position and euler rotation
//-----------------------------------------------------------------------------
float4x4 createWorldMatrix(float3 pos, float3 rot)
{
    float4x4 eleMatrix = {
        float4( cos(rot.z) * cos(rot.y) - sin(rot.z) * sin(rot.x) * sin(rot.y), 
                cos(rot.y) * sin(rot.z) + cos(rot.z) * sin(rot.x) * sin(rot.y), -cos(rot.x) * sin(rot.y), 0),
        float4( -cos(rot.x) * sin(rot.z), cos(rot.z) * cos(rot.x), sin(rot.x), 0),
        float4( cos(rot.z) * sin(rot.y) + cos(rot.y) * sin(rot.z) * sin(rot.x), sin(rot.z) * sin(rot.y) - 
                cos(rot.z) * cos(rot.y) * sin(rot.x), cos(rot.x) * cos(rot.y), 0),
        float4( pos.x,pos.y,pos.z, 1),
    };
	return eleMatrix;
}

//-----------------------------------------------------------------------------
// Inverse input 4x4 matrix
//-----------------------------------------------------------------------------
float4x4 inverseMatrix(float4x4 input)
{
    #define minor(a,b,c) determinant(float3x3(input.a, input.b, input.c))
     
    float4x4 cofactors = float4x4(
        minor(_22_23_24, _32_33_34, _42_43_44), 
        -minor(_21_23_24, _31_33_34, _41_43_44),
        minor(_21_22_24, _31_32_34, _41_42_44),
        -minor(_21_22_23, _31_32_33, _41_42_43),
         
        -minor(_12_13_14, _32_33_34, _42_43_44),
        minor(_11_13_14, _31_33_34, _41_43_44),
        -minor(_11_12_14, _31_32_34, _41_42_44),
        minor(_11_12_13, _31_32_33, _41_42_43),
         
        minor(_12_13_14, _22_23_24, _42_43_44),
        -minor(_11_13_14, _21_23_24, _41_43_44),
        minor(_11_12_14, _21_22_24, _41_42_44),
        -minor(_11_12_13, _21_22_23, _41_42_43),
         
        -minor(_12_13_14, _22_23_24, _32_33_34),
        minor(_11_13_14, _21_23_24, _31_33_34),
        -minor(_11_12_14, _21_22_24, _31_32_34),
        minor(_11_12_13, _21_22_23, _31_32_33)
     );
    #undef minor
    return transpose(cofactors) / determinant(input);
}

//-----------------------------------------------------------------------------
// Vertex Shader 
//----------------------------------------------------------------------------- 
PSInput VertexShaderFunction(VSInput VS)
{
    PSInput PS = (PSInput)0;
	
    float2 elementSize = sElementSize;
    if (!bIsDetailed) elementSize = sElementLow;

    VS.Position.xy /= float2(sScrSize.x, sScrSize.y);
    VS.Position.xy =  0.5 - VS.Position.xy;
    VS.Position.xy = VS.Position.yx;
    VS.Position.xy *= elementSize.xy;
    float4x4 sWorld = createWorldMatrix(sElementPosition, sElementRotation);
    float4 wPos = mul(float4(VS.Position, 1 ), sWorld);
    PS.WorldPos = wPos.xyz;

    float4x4 viewMainSceneInverse = inverseMatrix(gViewMainScene);
    PS.CameraPosition = viewMainSceneInverse[3].xyz;
	
    float4 vPos = mul(wPos, gViewMainScene);
    PS.DistFromCam = vPos.z / vPos.w;	

    float4 pPos = mul(vPos, gProjectionMainScene);
    PS.Position = pPos;
	
    float projectedX = (0.5 * (pPos.w + pPos.x));
    float projectedY = (0.5 * (pPos.w - pPos.y));
    PS.TexCoordProj = float3(projectedX, projectedY, pPos.w);   

    // Scroll noise texture
    float2 uvpos1 = 0;
    float2 uvpos2 = 0;

    uvpos1.x = sin(gTime/40);
    uvpos1.y = fmod(gTime/50,1);

    uvpos2.x = fmod(gTime/10,1);
    uvpos2.y = sin(gTime/12);

    VS.TexCoord.xy += sElementPosition.xy / elementSize;
    PS.TexCoord = VS.TexCoord.xy * elementSize;
    VS.TexCoord.xy *= elementSize / 24.0f ;
	
    PS.SparkleTex.x = VS.TexCoord.x * 1 + uvpos1.x ;
    PS.SparkleTex.y = VS.TexCoord.y * 1 + uvpos1.y ;
    PS.SparkleTex.z = VS.TexCoord.x * 2 + uvpos2.x ;
    PS.SparkleTex.w = VS.TexCoord.y * 2 + uvpos2.y ;

    return PS;
}

//------------------------------------------------------------------------------------------
// MTAApplyFogFade
//------------------------------------------------------------------------------------------
float MTAApplyFogFade( float texelAp, float3 worldPos, float3 cameraPosition )
{
    if ( !fFogEnable )
        return texelAp;

    float DistanceFromCamera = distance( cameraPosition, worldPos );
    float FogAmount = ( DistanceFromCamera - gFogStart )/( gFogEnd - gFogStart );
    texelAp = lerp(texelAp, 0, pow(saturate( FogAmount ), 2 ));
    return texelAp;
}

//-----------------------------------------------------------------------------
// Pixel shaders 
//-----------------------------------------------------------------------------
float4 PixelShaderFunctionDB(PSInput PS) : COLOR0
{
    float3 sCameraPosition = PS.CameraPosition;
    float2 distFromCam = float2( distance(sCameraPosition.x, PS.WorldPos.x), distance(sCameraPosition.y, PS.WorldPos.y));
    if (((distFromCam.x < sElementSize.x * 0.5  ) && (distFromCam.y < sElementSize.y * 0.5 )) && !bIsDetailed) return 0;

    float3 vFlakesNormal1 = tex2D(RandomSampler,PS.SparkleTex.xy).rgb;
    float3 vFlakesNormal2 = tex2D(RandomSampler,PS.SparkleTex.zw).rgb;
    float3 vFlakesNormal = (vFlakesNormal1 + vFlakesNormal2) / 2 ;
    vFlakesNormal = 2 * vFlakesNormal - 1.0;
	
    float2 TexCoordProj = PS.TexCoordProj.xy / PS.TexCoordProj.z;
    TexCoordProj += float2(0.0006, 0.0006);
	
    float depth = Linearize(FetchDepthBufferValue(TexCoordProj.xy));

    float3 fvNormal = float3(vFlakesNormal.x * gNormalStrength.x, vFlakesNormal.y * gNormalStrength.y, vFlakesNormal.z * gNormalStrength.z);
    float depthAlt = Linearize(FetchDepthBufferValue(TexCoordProj.xy + fvNormal.xy));
    float blurFactor = saturate((depthAlt - PS.DistFromCam) * 0.95);
	
    float4 finalColor = tex2D(ProjectiveSampler, TexCoordProj.xy + fvNormal.xy * blurFactor);
    finalColor.a *= MTAApplyFogFade(finalColor.a, PS.WorldPos, sCameraPosition);
    finalColor.a *= gAlpha;
	
    if (depth < PS.DistFromCam) finalColor.a = 0;
	
    return saturate(finalColor);
}

float4 PixelShaderFunction(PSInput PS) : COLOR0
{
    float3 sCameraPosition = PS.CameraPosition;
    float2 distFromCam = float2( distance(sCameraPosition.x, PS.WorldPos.x), distance(sCameraPosition.y, PS.WorldPos.y));
    if (((distFromCam.x < sElementSize.x * 0.5  ) && (distFromCam.y < sElementSize.y * 0.5 )) && !bIsDetailed) return 0;
	
    float3 vFlakesNormal1 = tex2D(RandomSampler,PS.SparkleTex.xy).rgb;
    float3 vFlakesNormal2 = tex2D(RandomSampler,PS.SparkleTex.zw).rgb;
    float3 vFlakesNormal = (vFlakesNormal1 + vFlakesNormal2) / 2 ;
    vFlakesNormal = 2 * vFlakesNormal - 1.0;	
	
    float3 projCoord = float3((PS.TexCoordProj.xy / PS.TexCoordProj.z),0) ;
    float3 fvNormal = float3(vFlakesNormal.x * gNormalStrength.x, vFlakesNormal.y * gNormalStrength.y, vFlakesNormal.z * gNormalStrength.z);
    projCoord.xy += float2(fvNormal.x ,fvNormal.y);	
	
    float4 finalColor = tex2D(ProjectiveSampler, projCoord.xy);
    finalColor.a *= MTAApplyFogFade(finalColor.a, PS.WorldPos, sCameraPosition);
    finalColor.a *= gAlpha;
    return saturate(finalColor);
}

//-----------------------------------------------------------------------------
// Techniques
//-----------------------------------------------------------------------------
technique dxDrawImage4D
{
  pass P0
  {
    AlphaRef = 1;
    AlphaBlendEnable = true;
    FogEnable = false;
    VertexShader = compile vs_2_0 VertexShaderFunction();
    PixelShader  = compile ps_2_0 PixelShaderFunctionDB();
  }
}

technique dxDrawImage4D_noDBuff
{
  pass P0
  {
    AlphaRef = 1;
    AlphaBlendEnable = true;
    FogEnable = false;
    VertexShader = compile vs_2_0 VertexShaderFunction();
    PixelShader  = compile ps_2_0 PixelShaderFunction();
  }
} 
	