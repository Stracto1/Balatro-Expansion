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
	//I saw video where it used a spiral shader to get the hue value but didn't manage to pull it off...
	//so I used an elipse-like shape instead 
	vec4 Color = Color0 * texture2D(Texture0, TexCoord0);
	int enable = 1;
	if (Color.rgb == vec3(0))
		enable = 0; //black doesn't change

	vec2 Center = vec2(0.7,0.65);//center of the elipse

	float Distance = distance(vec2(TexCoord0.x, TexCoord0.y/2), Center); 
	float ColorHue = sin(Distance * 4.5) * sin(Distance * 4.5); //gets the hue basing on the distance from the circles

	vec3 NewColor = hsv2rgb(vec3(ColorHue, 1, 1)); //tunes down a bit the colors and moves the hue

	Color.rgb = mix(Color.rgb, NewColor, 0.25 * enable);

	gl_FragColor = Color;
}

