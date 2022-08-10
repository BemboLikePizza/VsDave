package;

import flixel.system.FlxAssets.FlxShader;

class GlitchEffect
{
    public var shader(default,null):GlitchShader = new GlitchShader();

    public var waveSpeed(default, set):Float = 0;
	public var waveFrequency(default, set):Float = 0;
	public var waveAmplitude(default, set):Float = 0;
    public var Enabled(default, set):Bool = true;

	public function new():Void
	{
		shader.uTime.value = [0];
	}

    public function update(elapsed:Float):Void
    {
        shader.uTime.value[0] += elapsed;
    }

    function set_waveSpeed(v:Float):Float
    {
        waveSpeed = v;
        shader.uSpeed.value = [waveSpeed];
        return v;
    }
    function set_Enabled(v:Bool):Bool
    {
        Enabled = v;
        shader.uEnabled.value = [Enabled];
        return v;
    }
    
    function set_waveFrequency(v:Float):Float
    {
        waveFrequency = v;
        shader.uFrequency.value = [waveFrequency];
        return v;
    }
    
    function set_waveAmplitude(v:Float):Float
    {
        waveAmplitude = v;
        shader.uWaveAmplitude.value = [waveAmplitude];
        return v;
    }

}

class DistortBGEffect
{
    public var shader(default,null):DistortBGShader = new DistortBGShader();

    public var waveSpeed(default, set):Float = 0;
	public var waveFrequency(default, set):Float = 0;
	public var waveAmplitude(default, set):Float = 0;

	public function new():Void
	{
		shader.uTime.value = [0];
	}

    public function update(elapsed:Float):Void
    {
        shader.uTime.value[0] += elapsed;
    }


    function set_waveSpeed(v:Float):Float
    {
        waveSpeed = v;
        shader.uSpeed.value = [waveSpeed];
        return v;
    }
    
    function set_waveFrequency(v:Float):Float
    {
        waveFrequency = v;
        shader.uFrequency.value = [waveFrequency];
        return v;
    }
    
    function set_waveAmplitude(v:Float):Float
    {
        waveAmplitude = v;
        shader.uWaveAmplitude.value = [waveAmplitude];
        return v;
    }

}


class PulseEffect
{
    public var shader(default,null):PulseShader = new PulseShader();

    public var waveSpeed(default, set):Float = 0;
	public var waveFrequency(default, set):Float = 0;
	public var waveAmplitude(default, set):Float = 0;
    public var Enabled(default, set):Bool = false;

	public function new():Void
	{
		shader.uTime.value = [0];
        shader.uampmul.value = [0];
        shader.uEnabled.value = [false];
	}

    public function update(elapsed:Float):Void
    {
        shader.uTime.value[0] += elapsed;
    }


    function set_waveSpeed(v:Float):Float
    {
        waveSpeed = v;
        shader.uSpeed.value = [waveSpeed];
        return v;
    }

    function set_Enabled(v:Bool):Bool
    {
        Enabled = v;
        shader.uEnabled.value = [Enabled];
        return v;
    }
    
    function set_waveFrequency(v:Float):Float
    {
        waveFrequency = v;
        shader.uFrequency.value = [waveFrequency];
        return v;
    }
    
    function set_waveAmplitude(v:Float):Float
    {
        waveAmplitude = v;
        shader.uWaveAmplitude.value = [waveAmplitude];
        return v;
    }

}


class InvertColorsEffect
{
    public var shader(default,null):InvertShader = new InvertShader();

}

class BlockedGlitchEffect
{
    public var shader(default, null):BlockedGlitchShader = new BlockedGlitchShader();

    public var time(default, set):Float = 0;
    public var colorMultiplier(default, set):Float = 0;
    public var hasColorTransform(default, set):Bool = false;

    public function new(res:Float, time:Float, colorMultiplier:Float, colorTransform:Bool):Void
    {
        set_time(time);
        set_colorMultiplier(colorMultiplier);
        set_hasColorTransform(colorTransform);
    }
    public function update(elapsed:Float):Void
    {
        shader.time.value[0] += elapsed;
    }

	function set_hasColorTransform(value:Bool):Bool {
		this.hasColorTransform = value;
        shader.hasColorTransform.value = [hasColorTransform];
        return hasColorTransform;
	}

	function set_colorMultiplier(value:Float):Float {
        this.colorMultiplier = value;
        shader.colorMultiplier.value = [value];
        return this.colorMultiplier;
    }

	function set_time(value:Float):Float {
        this.time = value;
        shader.time.value = [value];
        return this.time;
    }
}

class GlitchShader extends FlxShader
{
    @:glFragmentSource('
    #pragma header
    //uniform float tx, ty; // x,y waves phase

    //modified version of the wave shader to create weird garbled corruption like messes
    uniform float uTime;
    
    /**
     * How fast the waves move over time
     */
    uniform float uSpeed;
    
    /**
     * Number of waves over time
     */
    uniform float uFrequency;

    uniform bool uEnabled;
    
    /**
     * How much the pixels are going to stretch over the waves
     */
    uniform float uWaveAmplitude;

    vec2 sineWave(vec2 pt)
    {
        float x = 0.0;
        float y = 0.0;
        
        float offsetX = sin(pt.y * uFrequency + uTime * uSpeed) * (uWaveAmplitude / pt.x * pt.y);
        float offsetY = sin(pt.x * uFrequency - uTime * uSpeed) * (uWaveAmplitude / pt.y * pt.x);
        pt.x += offsetX; // * (pt.y - 1.0); // <- Uncomment to stop bottom part of the screen from moving
        pt.y += offsetY;

        return vec2(pt.x + x, pt.y + y);
    }

    void main()
    {
        vec2 uv = sineWave(openfl_TextureCoordv);
        gl_FragColor = texture2D(bitmap, uv);
    }')

    public function new()
    {
       super();
    }
}

class InvertShader extends FlxShader
{
    @:glFragmentSource('
    #pragma header
    

    vec4 sineWave(vec4 pt)
    {
        return vec4(1.0 - pt.x, 1.0 - pt.y, 1.0 - pt.z, pt.w);
    }

    void main()
    {
        vec2 uv = openfl_TextureCoordv;
        gl_FragColor = sineWave(texture2D(bitmap, uv));
    }')

    public function new()
    {
       super();
    }
}



class DistortBGShader extends FlxShader
{
    @:glFragmentSource('
    #pragma header
    //uniform float tx, ty; // x,y waves phase

    //gives the character a glitchy, distorted outline
    uniform float uTime;
    
    /**
     * How fast the waves move over time
     */
    uniform float uSpeed;
    
    /**
     * Number of waves over time
     */
    uniform float uFrequency;
    
    /**
     * How much the pixels are going to stretch over the waves
     */
    uniform float uWaveAmplitude;

    vec2 sineWave(vec2 pt)
    {
        float x = 0.0;
        float y = 0.0;
        
        float offsetX = sin(pt.x * uFrequency + uTime * uSpeed) * (uWaveAmplitude / pt.x * pt.y);
        float offsetY = sin(pt.y * uFrequency - uTime * uSpeed) * (uWaveAmplitude);
        pt.x += offsetX; // * (pt.y - 1.0); // <- Uncomment to stop bottom part of the screen from moving
        pt.y += offsetY;

        return vec2(pt.x + x, pt.y + y);
    }

    vec4 makeBlack(vec4 pt)
    {
        return vec4(0, 0, 0, pt.w);
    }

    void main()
    {
        vec2 uv = sineWave(openfl_TextureCoordv);
        gl_FragColor = makeBlack(texture2D(bitmap, uv)) + texture2D(bitmap,openfl_TextureCoordv);
    }')

    public function new()
    {
       super();
    }
}


class PulseShader extends FlxShader
{
    @:glFragmentSource('
    #pragma header
    uniform float uampmul;

    //modified version of the wave shader to create weird garbled corruption like messes
    uniform float uTime;
    
    /**
     * How fast the waves move over time
     */
    uniform float uSpeed;
    
    /**
     * Number of waves over time
     */
    uniform float uFrequency;

    uniform bool uEnabled;
    
    /**
     * How much the pixels are going to stretch over the waves
     */
    uniform float uWaveAmplitude;

    vec4 sineWave(vec4 pt, vec2 pos)
    {
        if (uampmul > 0.0)
        {
            float offsetX = sin(pt.y * uFrequency + uTime * uSpeed);
            float offsetY = sin(pt.x * (uFrequency * 2) - (uTime / 2) * uSpeed);
            float offsetZ = sin(pt.z * (uFrequency / 2) + (uTime / 3) * uSpeed);
            pt.x = mix(pt.x,sin(pt.x / 2 * pt.y + (5 * offsetX) * pt.z),uWaveAmplitude * uampmul);
            pt.y = mix(pt.y,sin(pt.y / 3 * pt.z + (2 * offsetZ) - pt.x),uWaveAmplitude * uampmul);
            pt.z = mix(pt.z,sin(pt.z / 6 * (pt.x * offsetY) - (50 * offsetZ) * (pt.z * offsetX)),uWaveAmplitude * uampmul);
        }
        return vec4(pt.x, pt.y, pt.z, pt.w);
    }

    void main()
    {
        vec2 uv = openfl_TextureCoordv;
        gl_FragColor = sineWave(texture2D(bitmap, uv),uv);
    }')

    public function new()
    {
       super();
    }
}

class BlockedGlitchShader extends FlxShader
{
    @:glFragmentSource('
    #pragma header

    // ---- gllock required fields -----------------------------------------------------------------------------------------
    #define RATE 0.75
    
    uniform float time;
    uniform float end;
    uniform sampler2D imageData;
    uniform vec2 screenSize;
    // ---------------------------------------------------------------------------------------------------------------------
    
    float rand(vec2 co){
      return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453) * 2.0 - 1.0;
    }
    
    float offset(float blocks, vec2 uv) {
      float shaderTime = time*RATE;
      return rand(vec2(shaderTime, floor(uv.y * blocks)));
    }
    
    void main(void) {
      vec2 uv = vec2(1,-1)*gl_FragCoord.xy / screenSize;
      gl_FragColor = texture(imageData, uv);
      gl_FragColor.r = texture(imageData, uv + vec2(offset(64.0, uv) * 0.03, 0.0)).r;
      gl_FragColor.g = texture(imageData, uv + vec2(offset(64.0, uv) * 0.03 * 0.16666666, 0.0)).g;
      gl_FragColor.b = texture(imageData, uv + vec2(offset(64.0, uv) * 0.03, 0.0)).b;
    }
    ')

    public function new()
    {
        super();
    }
}