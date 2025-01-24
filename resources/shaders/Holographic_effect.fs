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


void main(void){
	//tried as hard as i could to make this as similar the original as possible, it's not EXACLTY the same but good enough for me
	//if you have some suggestions please let me know!!
	vec4 Color = Color0 * texture2D(Texture0, TexCoord0);
	int enable = 1; 
	if (Color.rgb == vec3(0))
		enable = 0; //pure black doesn't get affected by the shader

	TexCoord0.y = 1 - TexCoord0.y; //unflips the y coordinate
	TexCoord0.xy = fract(TexCoord0 * 8); //makes the pattern repeat over the texture

	float mixAmount = step(TexCoord0.x/2,TexCoord0.y)*step(TexCoord0.y,1-TexCoord0.x/2);//this basically decides whether it's green or red
	vec3 Red = vec3(1,0.65 * TexCoord0.x,0);			//the colors vary a little basing on the position
	vec3 Green = vec3(0.2,1.1 - TexCoord0.x, 0.9 * TexCoord0.x);
	vec3 PureColor = mix(Red,Green, mixAmount); 		//decides of it's red or green
	
	Color.rgb = mix(Color.rgb, PureColor, 0.3 * enable);   //mixes the original sprite pixel with the green/red (except for black)

	gl_FragColor = Color;//finished!
}

