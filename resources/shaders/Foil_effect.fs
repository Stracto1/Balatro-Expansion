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
	vec4 Color = Color0 * texture2D(Texture0, TexCoord0);
	int mult = 1; 
	if (Color.rgb == vec3(0))
		mult = 0; //pure black doesn't get affected by the shader


	vec2 Center = vec2(0.5,0.5); //center of the circles

	float Distance = distance(TexCoord0,Center);
	vec3 Blue = vec3(0.3,0.5,1);

	vec3 FinalColor = mix(Blue , vec3(1),0.7*cos(Distance * 75) *cos(Distance * 75) ); //makes pixels that touch the circles brighter
	Color.rgb = mix(Color.rgb, FinalColor, 0.33 * mult); 

	gl_FragColor = Color;
}

