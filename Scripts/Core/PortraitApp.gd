extends Node

# Global display policy: portrait-first for every platform.
# Mobile uses the project orientation setting. Desktop keeps a portrait window
# sized to fit the usable screen so the full vertical layout remains visible.
const BASE_SIZE := Vector2i(720, 1280)
const DESKTOP_MARGIN := 120
const DESKTOP_MAX_WIDTH := 720
const DESKTOP_MAX_HEIGHT := 1280

func _ready() -> void:
	RenderingServer.set_default_clear_color(Color("#cfe8f7"))
	get_window().min_size = Vector2i(360, 640)

	if OS.has_feature("mobile"):
		return

	_fit_desktop_portrait_window()

func _fit_desktop_portrait_window() -> void:
	var usable := DisplayServer.screen_get_usable_rect()
	if usable.size.x <= 0 or usable.size.y <= 0:
		get_window().size = Vector2i(540, 960)
		return

	var max_height := min(DESKTOP_MAX_HEIGHT, usable.size.y - DESKTOP_MARGIN)
	var max_width := min(DESKTOP_MAX_WIDTH, usable.size.x - 40)
	var height := max(640, max_height)
	var width := int(round(float(height) * float(BASE_SIZE.x) / float(BASE_SIZE.y)))

	if width > max_width:
		width = max_width
		height = int(round(float(width) * float(BASE_SIZE.y) / float(BASE_SIZE.x)))

	width = max(360, width)
	height = max(640, height)
	get_window().size = Vector2i(width, height)

	var position := usable.position + (usable.size - Vector2i(width, height)) / 2
	get_window().position = position
