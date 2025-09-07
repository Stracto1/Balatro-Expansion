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
	
	//vec4 Color = Color0 * texture2D(Texture0, TexCoord0);
	int mult = 1; 
	if (((ColorHSV.b <= 0.3)&&(ColorHSV.g <= 0.4))||(ColorHSV.b <= 0.04))
		mult = 0; //black-ish doesn't get affected by the shader


	vec2 Center = vec2(0.5,0.5); //center of the circles

	float Distance = distance(TrueCoord,Center);
	vec3 Blue = vec3(0.3,0.52,1);

	vec3 FinalColor = mix(Blue , vec3(1), 0.6 * cos(Distance * 75)*cos(Distance * 75) ); //makes pixels that touch the circles brighter
	Color.rgb = mix(Color.rgb, FinalColor, 0.33 * mult); 

	gl_FragColor = Color;
}

