#ifndef GL_ES
#  define lowp
#  define mediump
#endif

varying lowp vec4 Color0;
varying mediump vec2 TexCoord0;
varying lowp vec4 ColorizeOut;
varying lowp vec3 ColorOffsetOut;
varying lowp vec2 TextureSizeOut;
varying lowp float PixelationAmountOut;
varying lowp vec3 ClipPlaneOut;

uniform sampler2D Texture0;


void main(void)
{

		// Clip
	if(dot(gl_FragCoord.xy, ClipPlaneOut.xy) < ClipPlaneOut.z)
		discard;

	vec2 Ratio = vec2(32.0)/TextureSizeOut;

	vec2 TrueCoord = TexCoord0;

	TrueCoord.xy = fract(TrueCoord/Ratio); //makes the pattern repeat over the whole sprite (bigger sprites are divided in a grid of 32x32)

	// Pixelate
	vec2 pa = vec2(1.0+PixelationAmountOut, 1.0+PixelationAmountOut) / TextureSizeOut;
	vec4 Color = Color0 * texture2D(Texture0, PixelationAmountOut > 0.0 ? TexCoord0 - mod(TexCoord0, pa) + pa * 0.5 : TexCoord0);
		
 
	float LeftLineHeight = 1.66*TrueCoord.x - 0.33; // " / " segment of the x
	float RightLineHeight = 1.0 - LeftLineHeight;     // " \ " segment of the x

	vec3 Red = vec3(0.92,0.2,0.23);

	
	float RedEnable;
	float mult = (Color.rgb == vec3(0.0)) ? 0.0 : 1.0; //pure black doesn't get affected by the shader

	float Thickness = 0.1;
	
	RedEnable = step(abs(RightLineHeight - TrueCoord.y), Thickness);

	RedEnable = RedEnable + step(abs(LeftLineHeight - TrueCoord.y), Thickness);
	
	RedEnable = min(RedEnable, 1.0); // in the end either 0 or 1


	Color.rgb = mix(Color.rgb, Red, 0.5 * RedEnable * mult); // red tint
	Color = RedEnable >= 1.0 ? Color : vec4(0.0);

	gl_FragColor = Color;
}

