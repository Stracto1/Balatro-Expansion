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


vec3 rgb2hsv(vec3 c) //thank you random person on the internet!
{
    vec4 K = vec4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
    vec4 p = mix(vec4(c.bg, K.wz), vec4(c.gb, K.xy), step(c.b, c.g));
    vec4 q = mix(vec4(p.xyw, c.r), vec4(c.r, p.yzx), step(p.x, c.r));

    float d = q.x - min(q.w, q.y);
    float e = 1.0e-10;
    return vec3(abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
}

vec3 hsv2rgb(vec3 c) //aaand thank you again!
{
    vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
    vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
    return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
}


void main(void){
	//tried as hard as i could to make this as similar the original as possible, it's not EXACLTY the same but good enough for me
	//if you have some suggestions please let me know!!

		// Clip
	if(dot(gl_FragCoord.xy, ClipPlaneOut.xy) < ClipPlaneOut.z)
		discard;

	vec2 Ratio = vec2(32.0)/TextureSizeOut;

	vec2 TrueCoord = TexCoord0;

	TrueCoord.xy = fract(TrueCoord/Ratio); //makes the pattern repeat over the whole sprite (bigger sprites are divided in a grid of 32x32)

	// Pixelate
	vec2 pa = vec2(1.0+PixelationAmountOut, 1.0+PixelationAmountOut) / TextureSizeOut;
	vec4 Color = Color0 * texture2D(Texture0, PixelationAmountOut > 0.0 ? TexCoord0 - mod(TexCoord0, pa) + pa * 0.5 : TexCoord0);
	vec3 ColorHSV = rgb2hsv(Color.rgb);

	float enable = 1.0; 
	if (((ColorHSV.b <= 0.3)&&(ColorHSV.g <= 0.4))||(ColorHSV.b <= 0.04))
		enable = 0.1; //black-ish doesn't get affected by the shader

	TrueCoord.y = 1.0 - TrueCoord.y; //unflips the y coordinate
	TrueCoord.xy = fract(TrueCoord * 8.0); //makes the pattern repeat over the texture

	float mixAmount = step(TrueCoord.x/2.0,TrueCoord.y)*step(TrueCoord.y,1.0-TrueCoord.x/2.0);//this basically decides whether it's green or red
	vec3 Red = vec3(1.0,0.65 * TrueCoord.x,0.0);			//the colors vary a little basing on the position
	vec3 Green = vec3(0.2,1.1 - TrueCoord.x, 0.9 * TrueCoord.x);
	vec3 PureColor = mix(Red,Green, mixAmount); 		//decides of it's red or green
	
	Color.rgb = mix(Color.rgb, PureColor, 0.3 * enable);   //mixes the original sprite pixel with the green/red

	gl_FragColor = Color;//finished!
}

