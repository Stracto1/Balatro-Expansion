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


void main(void)
{
	//apparently balatro's negative effect is nowhere near an actual negative filter, so
	//I tried to read the original shader but had a stroke while doing so (incredible godzilla reference)
	//tried a method i found on reddit and it works quite well

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

	if ((Color.r <= (8.0/255.0))&&(Color.gb == vec2(0))) //mf nicalis black i hate you
		ColorHSV.g = 0;

	ColorHSV.b = 1 - ColorHSV.b + ColorHSV.g*0.56; //inverts the value of the color, but reducing the effect for saturated values

	ColorHSV.r = (1 - ColorHSV.r) + 0.18; //inverts and moves the hue a bit
	Color.rgb = hsv2rgb(ColorHSV.rgb);


	float YshinePoint = -1.75*TrueCoord.x + 0.18; //where the shine effect peak should be

	TrueCoord.y = TrueCoord.y - 0.5*sin((TrueCoord.x*1.55 - 0.4)*3.1415); //literally threw in some random shit and made it much cooler idk

	float Distance = YshinePoint - TrueCoord.y; //the distance from the shine point

	Color.rgb = mix(Color.rgb, vec3(0.9,0.9,1), clamp(0.31*cos(Distance * 12),0.0, 0.6)); //make it shine!
	
	gl_FragColor = Color;
}

