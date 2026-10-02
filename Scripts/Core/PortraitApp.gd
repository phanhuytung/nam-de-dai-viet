extends Node

# Global display policy for the portrait Login scene and future screens.
# 720x1280 is the authoring/design size only; the real desktop window
# is calculated from the current usable display at runtime.

const DESIGN_SIZE: Vector2i = Vector2i(720, 1280)
const MIN_WINDOW_SIZE: Vector2i = Vector2i(360, 640)
const DESKTOP_HEIGHT_RATIO: float = 0.84
const PORTRAIT_ASPECT: float = float(DESIGN_SIZE.x) / float(DESIGN_SIZE.y)

func _ready() -> void:
	RenderingServer.set_default_clear_color(Color("#cfe8f7"))
	get_window().min_size = MIN_WINDOW_SIZE

	if OS.has_feature("mobile"):
		return

	_fit_desktop_portrait_window()

func _fit_desktop_portrait_window() -> void:
	var usable: Rect2i = DisplayServer.screen_get_usable_rect()

	if usable.size.x <= 0 or usable.size.y <= 0:
		return

	var height: int = int(round(float(usable.size.y) * DESKTOP_HEIGHT_RATIO))
	var width: int = int(round(float(height) * PORTRAIT_ASPECT))

	if width > usable.size.x:
		width = usable.size.x
		height = int(round(float(width) / PORTRAIT_ASPECT))

	width = max(MIN_WINDOW_SIZE.x, width)
	height = max(MIN_WINDOW_SIZE.y, height)

	if width > usable.size.x or height > usable.size.y:
		var scale: float = min(
			float(usable.size.x) / float(width),
			float(usable.size.y) / float(height)
		)
		width = max(1, int(floor(float(width) * scale)))
		height = max(1, int(floor(float(height) * scale)))

	get_window().size = Vector2i(width, height)
	get_window().position = usable.position + (usable.size - Vector2i(width, height)) / 2
