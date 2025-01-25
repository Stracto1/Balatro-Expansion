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
	//this literally does nothing, just didn't want to put an extra if statement in joker's edition render
	vec4 Color = Color0 * texture2D(Texture0, TexCoord0);
	gl_FragColor = Color;
}

