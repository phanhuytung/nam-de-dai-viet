extends Node

const DESIGN_SIZE: Vector2i = Vector2i(1280, 2340)
const MIN_WINDOW_SIZE: Vector2i = Vector2i(360, 640)
const DESKTOP_HEIGHT_RATIO: float = 0.84
const PORTRAIT_ASPECT: float = float(DESIGN_SIZE.x) / float(DESIGN_SIZE.y)

func _ready() -> void:
	RenderingServer.set_default_clear_color(Color("#cfe8f7"))
	var window: Window = get_window()
	window.min_size = MIN_WINDOW_SIZE
	if OS.has_feature("mobile"):
		return
	_fit_desktop_portrait_window()

func _fit_desktop_portrait_window() -> void:
	var screen_size: Vector2i = DisplayServer.screen_get_size()
	var usable: Rect2i = DisplayServer.screen_get_usable_rect()
	if screen_size.x <= 0 or screen_size.y <= 0 or usable.size.x <= 0 or usable.size.y <= 0:
		return

	var target_height: int = int(floor(float(usable.size.y) * DESKTOP_HEIGHT_RATIO))
	var target_width: int = int(floor(float(target_height) * PORTRAIT_ASPECT))

	if target_width > usable.size.x:
		target_width = usable.size.x
		target_height = int(floor(float(target_width) / PORTRAIT_ASPECT))

	if target_height > usable.size.y:
		target_height = usable.size.y
		target_width = int(floor(float(target_height) * PORTRAIT_ASPECT))

	if usable.size.x >= MIN_WINDOW_SIZE.x and usable.size.y >= MIN_WINDOW_SIZE.y:
		if target_width < MIN_WINDOW_SIZE.x:
			target_width = MIN_WINDOW_SIZE.x
			target_height = int(floor(float(target_width) / PORTRAIT_ASPECT))
		if target_height < MIN_WINDOW_SIZE.y:
			target_height = MIN_WINDOW_SIZE.y
			target_width = int(floor(float(target_height) / PORTRAIT_ASPECT))

	if target_width > usable.size.x or target_height > usable.size.y:
		target_width = min(target_width, usable.size.x)
		target_height = int(floor(float(target_width) / PORTRAIT_ASPECT))
		if target_height > usable.size.y:
			target_height = usable.size.y
			target_width = int(floor(float(target_height) * PORTRAIT_ASPECT))

	if target_width <= 0 or target_height <= 0:
		return

	var window_size := Vector2i(target_width, target_height)
	var window_position := usable.position + (usable.size - window_size) / 2
	var window: Window = get_window()
	window.size = window_size
	window.position = window_position
	_print_display_info(screen_size, usable, window_size)

func _print_display_info(screen_size: Vector2i, usable: Rect2i, window_size: Vector2i) -> void:
	print("========== PORTRAIT DISPLAY ==========")
	print("Real screen size : ", screen_size)
	print("Usable screen    : ", usable.size)
	print("Usable position  : ", usable.position)
	print("Game window      : ", window_size)
	print("Window position  : ", get_window().position)
	print("Design canvas    : ", DESIGN_SIZE)
	print("Portrait ratio   : ", PORTRAIT_ASPECT)
	print("Height ratio     : ", DESKTOP_HEIGHT_RATIO)
	print("======================================")