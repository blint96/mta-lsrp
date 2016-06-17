//
// file: tex_water.fx
// Watershine and other bits and pieces by Ren712
//

//---------------------------------------------------------------------
// Variables
//---------------------------------------------------------------------
texture sReflectionTexture;
texture sRandomTexture;

float4 sWaterColor = float4(90 / 255.0, 170 / 255.0, 170 / 255.0, 240 / 255.0 );
float sWatFadeStart = 90;
float sWatFadeEnd = 230;

float sSpecularBrightness = 1;
float3 sLightDir = float3(0,-0.5,-0.5);
float sSpecularPower = 4;
float sVisibility = 0;
float4 sSunColorTop = float4(1,1,1,1);
float4 sSunColorBott = float4(1,1,1,1);

float sFadeStart = 140;
float sFadeEnd = 300;

float sNormalStrength = 1;
bool bAnimWaves = true;
float gAlpha = 0.95;

//---------------------------------------------------------------------
// Include some common stuff
//---------------------------------------------------------------------
float4x4 gWorld : WORLD;
float4x4 gView : VIEW;
float4x4 gProjection : PROJECTION;
float4x4 gViewProjection : VIEWPROJECTION;
float4x4 gWorldViewProjection : WORLDVIEWPROJECTION;
float4x4 gViewInverse : VIEWINVERSE;
float3 gCameraDirection : CAMERADIRECTION;
texture gDepthBuffer : DEPTHBUFFER;
texture gTexture0 < string textureState="0,Texture"; >;
matrix gProjectionMainScene : PROJECTION_MAIN_SCENE;
float3 gCameraPosition : CAMERAPOSITION;
float3 gCameraRotation : CAMERAROTATION;
int CUSTOMFLAGS <string skipUnusedParameters = "yes"; >;
int gFogEnable < string renderState="FOGENABLE"; >;
float4 gFogColor < string renderState="FOGCOLOR"; >;
float gFogStart < string renderState="FOGSTART"; >;
float gFogEnd < string renderState="FOGEND"; >;
float gTime : TIME;

//------------------------------------------------------------------------------------------
// Samplers for the textures
//------------------------------------------------------------------------------------------
sampler2D RandomSampler = sampler_state
{
    Texture = (sRandomTexture);
    MagFilter = Linear;
    MinFilter = Linear;
    MipFilter = Linear;
    MipMapLODBias = 0.000000;
};

samplerCUBE ReflectionSampler = sampler_state
{
    Texture = (sReflectionTexture);
    MagFilter = Linear;
    MinFilter = Linear;
    MipFilter = Linear;
    MIPMAPLODBIAS = 0.000000;
};

sampler SamplerDepth = sampler_state
{
    Texture     = (gDepthBuffer);
    AddressU    = Clamp;
    AddressV    = Clamp;
};

sampler Sampler0 = sampler_state
{
    Texture     = (gTexture0);
};
//---------------------------------------------------------------------
// Structure of data sent to the vertex shader
//---------------------------------------------------------------------
struct VSInput
{
    float4 Position : POSITION0;
    float4 Diffuse : COLOR0;
    float2 TexCoord : TEXCOORD0;
    float3 Normal : NORMAL0;
};

//---------------------------------------------------------------------
// Structure of data sent to the pixel shader ( from the vertex shader )
//---------------------------------------------------------------------
struct PSInput
{
    float4 Position : POSITION0;
    float4 Diffuse : COLOR0;
    float4 WorldPos : TEXCOORD0;
    float4 SparkleTex : TEXCOORD1;
    float3 Normal : TEXCOORD2;
    float WatDistFade : TEXCOORD3;
    float DistFade : TEXCOORD4;
    float2 TexCoord : TEXCOORD5;
    float4 ProjPos : TEXCOORD6;
    float DistFromCam : TEXCOORD7;
};


//------------------------------------------------------------------------------------------
// MTAUnlerp
// - Find a the relative position between 2 values
//------------------------------------------------------------------------------------------
float MTAUnlerp( float from, float to, float pos )
{
    if ( from == to )
        return 1.0;
    else
        return ( pos - from ) / ( to - from );
}

//------------------------------------------------------------------------------------------
// VertexShaderFunction
//------------------------------------------------------------------------------------------
PSInput VertexShaderFunction(VSInput VS)
{
    PSInput PS = (PSInput)0;

    // Calculate screen pos of vertex
    PS.Position = mul(VS.Position,gWorldViewProjection);

    // Convert regular water color to what we want
    float4 waterColorBase = float4(90 / 255.0, 170 / 255.0, 170 / 255.0, 240 / 255.0 );
    float4 conv           = float4(30 / 255.0,  58 / 255.0,  58 / 255.0, 200 / 255.0 );
    PS.Diffuse = saturate( sWaterColor * conv / waterColorBase );

    // Set information to do calculations in pixel shader
    PS.WorldPos = mul(VS.Position, gWorld);
	
    PS.TexCoord = VS.TexCoord;
	
    // Scroll noise texture
    float2 uvpos1 = 0;
    float2 uvpos2 = 0;

    float fTime = bAnimWaves == true ? gTime : 0;
    uvpos1.x = sin(fTime/40);
    uvpos1.y = fmod(fTime/50,1);
    uvpos2.x = fmod(fTime/10,1);
    uvpos2.y = sin(fTime/12);

    PS.SparkleTex.x = VS.TexCoord.x * 1 + uvpos1.x;
    PS.SparkleTex.y = VS.TexCoord.y * 1 + uvpos1.y;
    PS.SparkleTex.z = VS.TexCoord.x * 2 + uvpos2.x;
    PS.SparkleTex.w = VS.TexCoord.y * 2 + uvpos2.y;

    PS.Normal =  float3(0,0,1);   

    float DistanceFromCam = distance( gCameraPosition, PS.WorldPos.xyz );
    PS.WatDistFade = MTAUnlerp ( sWatFadeEnd, sWatFadeStart, DistanceFromCam );
    PS.DistFade = MTAUnlerp ( sFadeEnd, sFadeStart, DistanceFromCam );
	
    return PS;
}

//------------------------------------------------------------------------------------------
// applyLiSpecular
//------------------------------------------------------------------------------------------

float3 applyLiSpecular(float3 color1, float3 color2, float3 normal,float3 lightDir, float3 worldPos, float specul) 
{	
    float3 h = normalize(normalize(gCameraPosition - worldPos) - normalize(lightDir));
    float spec = pow(saturate(dot(h, normal)* 0.5), specul);	
	
    float spec1 = saturate(pow(spec, specul));
    float spec2 = saturate(pow(spec, 2 * specul));
    float3 specular = spec1 * color1.rgb / 3 + spec2 * color2.rgb;
    return saturate( specular );
}

//------------------------------------------------------------------------------------------
// MTAApplyFog
//------------------------------------------------------------------------------------------
float3 MTAApplyFog( float3 texel, float3 worldPos )
{
    if ( !gFogEnable )
        return texel;
 
    float DistanceFromCamera = distance( gCameraPosition, worldPos );
    float FogAmount = ( DistanceFromCamera - gFogStart )/( gFogEnd - gFogStart );
    texel.rgb = lerp(texel.rgb, gFogColor, saturate( FogAmount ) );
    return texel;
}

//------------------------------------------------------------------------------------------
// PixelShaderFunction
//------------------------------------------------------------------------------------------
float4 PixelShaderFunction(PSInput PS) : COLOR0
{
    float3 vFlakesNormal = tex2D(RandomSampler, PS.SparkleTex.xy).rgb;
    float3 vFlakesNormal2 = tex2D(RandomSampler, PS.SparkleTex.zw).rgb;

    vFlakesNormal = (vFlakesNormal + vFlakesNormal2 ) / 2;
    vFlakesNormal = 2 * vFlakesNormal - 1.0;
    float3 vNp2 = ( vFlakesNormal + PS.Normal ) * sNormalStrength;
    float3 vView = normalize( gCameraPosition - PS.WorldPos.xyz );

    float3 vNormalWorld = float3(0,0,-1);
    float fNdotV = saturate(dot( vNormalWorld, vView));
    float3 vReflection = 2 * vNormalWorld * fNdotV - vView;
    vReflection += vNp2;

    float3 h = normalize(normalize(gCameraPosition - PS.WorldPos.xyz) - gCameraDirection);
    float vdn = saturate(dot(h,vNp2));
    float3 skyColor = gFogColor.rgb * vdn * saturate(PS.WatDistFade);	
	
    // Specular calculation
    float3 lightDir = normalize(sLightDir.xyz);
    float3 specLighting = applyLiSpecular(sSunColorTop, sSunColorBott, vNp2, lightDir, PS.WorldPos.xyz, sSpecularPower);

    // Sample environment map using this reflection vector:
    float4 envMap = texCUBE( ReflectionSampler, -vReflection );
    float envGray = (envMap.r + envMap.g + envMap.b)/3;
    envMap.rgb = float3(envGray,envGray,envGray);
    envMap.rgb = envMap.rgb * envMap.a;
	
    // Blend rays with water
    envGray = lerp(0.5,envGray,saturate(PS.WatDistFade));
    specLighting = specLighting * envGray * sSpecularBrightness;
	
    // Brighten the environment map sampling result:
    envMap.rgb *= vdn * 0.1;
    float4 finalColor = 1;

    // Bodge in the water color
    finalColor = envMap + PS.Diffuse * 0.5;
    finalColor += envMap * PS.Diffuse;
    finalColor.rgb += skyColor * 0.18 * PS.Diffuse.a;
    finalColor.rgb += specLighting * saturate(PS.DistFade) * sVisibility;
    finalColor.a = PS.Diffuse.a;
    finalColor.a *= gAlpha;
    return saturate(finalColor);
}


//------------------------------------------------------------------------------------------
// Techniques
//------------------------------------------------------------------------------------------
technique water2
{
    pass P0
    {
        AlphaBlendEnable = TRUE;
        AlphaRef = 1;
        VertexShader = compile vs_2_0 VertexShaderFunction();
        PixelShader  = compile ps_2_0 PixelShaderFunction();
    }
}

// Fallback
technique fallback
{
    pass P0
    {
        // Just draw normally
    }
}
