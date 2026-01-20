extern number time;

vec4 effect(vec4 color, Image tex, vec2 texCoord, vec2 screenCoord)
{
    vec2 uv = texCoord;

    // Distorção horizontal (ondas da fita)
    float wave = sin(uv.y * 10.0 + time * 2.0) * 0.001;
    uv.x += wave;

    // Separação RGB
    float offset = 0.002;
    float r = Texel(tex, uv + vec2(offset, 0.0)).r;
    float g = Texel(tex, uv).g;
    float b = Texel(tex, uv - vec2(offset, 0.0)).b;

    vec4 pixel = vec4(r, g, b, 1.0);

    // Ruído (granulado)
    float noise = fract(sin(dot(screenCoord.xy, vec2(12.9898,78.233))) * 43758.5453);
    pixel.rgb += noise * 0.05;

    // Scanlines
    float scanline = sin(uv.y * 800.0) * 0.04;
    pixel.rgb -= scanline;

    // Flicker (instabilidade)
    float flicker = 0.9 + sin(time * 10.0) * 0.05;
    pixel.rgb *= flicker;

    return pixel;
}
