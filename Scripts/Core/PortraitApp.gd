extends Node

# Global display policy:
# - Portrait orientation is the app policy, not a fixed pixel resolution.
# - 720x1280 is only the Godot design/base resolution for authoring UI.
# - The real window size is calculated from the actual display at runtime.
# - Wider displays keep the portrait content centered; extra horizontal space
#   shows the soft sky clear color instead of stretching the artwork.
const MIN_WINDOW_SIZE := Vector2i(360, 640)
const DESKTOP_HEIGHT_RATIO := 0.84
const PORTRAIT_ASPECT := 9.0 / 16.0

func _ready() -> void:
	RenderingServer.set_default_clear_color(Color("#cfe8f7"))
	get_window().min_size = MIN_WINDOW_SIZE

	if OS.has_feature("mobile"):
		return

	_fit_desktop_portrait_window()

func _fit_desktop_portrait_window() -> void:
	var usable := DisplayServer.screen_get_usable_rect()
	if usable.size.x <= 0 or usable.size.y <= 0:
		return

	# Size from the actual laptop/desktop screen, never from 720x1280.
	# The portrait aspect is preserved so the vertical UI remains predictable.
	var height := int(round(float(usable.size.y) * DESKTOP_HEIGHT_RATIO))
	var width := int(round(float(height) * PORTRAIT_ASPECT))

	# If the chosen portrait window is wider than the available screen,
	# constrain it by the real screen width and recalculate its height.
	if width > usable.size.x:
		width = usable.size.x
		height = int(round(float(width) / PORTRAIT_ASPECT))

	width = max(MIN_WINDOW_SIZE.x, width)
	height = max(MIN_WINDOW_SIZE.y, height)

	# Never allow the calculated window to exceed the usable display area.
	if width > usable.size.x or height > usable.size.y:
		var scale := min(
			float(usable.size.x) / float(width),
			float(usable.size.y) / float(height)
		)
		width = max(MIN_WINDOW_SIZE.x, int(floor(float(width) * scale)))
		height = max(MIN_WINDOW_SIZE.y, int(floor(float(height) * scale)))

	get_window().size = Vector2i(width, height)
	get_window().position = usable.position + (usable.size - Vector2i(width, height)) / 2
