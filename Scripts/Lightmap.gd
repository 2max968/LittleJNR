extends TextureRect

enum BlendModes{Additive, Sbtractive, Multiply};

export var colorLight : Color = Color(1, 1, 1);
export var colorDark : Color = Color(0.253906, 0.253906, 0.253906);
export(BlendModes) var blendMode = BlendModes.Additive;
export var scale : float = 0.25;

# Called when the node enters the scene tree for the first time.
func _ready():
	renderLightmap()

func renderLightmap():
	var img := Image.new();
	var size = rect_size;
	img.create(rect_size.x * scale, rect_size.y * scale, false, Image.FORMAT_RGBF)
	img.fill(colorLight);
	var tex := ImageTexture.new();
	tex.create_from_image(img);
	texture = tex
	expand = true
	
	
func pos2world(pos : Vector2):
	pos /= scale;
	pos += rect_position;
	return pos
