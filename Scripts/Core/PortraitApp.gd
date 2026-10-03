extends Node

const DESIGN_SIZE: Vector2i = Vector2i(1280, 2340)
const MIN_WINDOW_SIZE: Vector2i = Vector2i(360, 640)
const PORTRAIT_ASPECT: float = float(DESIGN_SIZE.x) / float(DESIGN_SIZE.y)


func _ready() -> void:
	RenderingServer.set_default_clear_color(Color("#cfe8f7"))

	var root_window: Window = get_tree().root
	root_window.content_scale_size = DESIGN_SIZE
	root_window.content_scale_mode = Window.CONTENT_SCALE_MODE_CANVAS_ITEMS
	root_window.content_scale_aspect = Window.CONTENT_SCALE_ASPECT_KEEP
	root_window.min_size = MIN_WINDOW_SIZE

	if OS.has_feature("mobile"):
		_print_display_info(DisplayServer.screen_get_size(), DisplayServer.screen_get_usable_rect(), root_window.size)
		return

	_fit_desktop_portrait_window()


func _fit_desktop_portrait_window() -> void:
	var screen_size: Vector2i = DisplayServer.screen_get_size()
	var usable: Rect2i = DisplayServer.screen_get_usable_rect()

	if screen_size.x <= 0 or screen_size.y <= 0:
		return

	if usable.size.x <= 0 or usable.size.y <= 0:
		return

	var target_height: int = usable.size.y
	var target_width: int = int(floor(float(target_height) * PORTRAIT_ASPECT))

	if target_width > usable.size.x:
		target_width = usable.size.x
		target_height = int(floor(float(target_width) / PORTRAIT_ASPECT))

	if target_width < MIN_WINDOW_SIZE.x and usable.size.x >= MIN_WINDOW_SIZE.x:
		target_width = MIN_WINDOW_SIZE.x
		target_height = int(floor(float(target_width) / PORTRAIT_ASPECT))

	if target_height < MIN_WINDOW_SIZE.y and usable.size.y >= MIN_WINDOW_SIZE.y:
		target_height = MIN_WINDOW_SIZE.y
		target_width = int(floor(float(target_height) * PORTRAIT_ASPECT))

	if target_width > usable.size.x:
		target_width = usable.size.x
		target_height = int(floor(float(target_width) / PORTRAIT_ASPECT))

	if target_height > usable.size.y:
		target_height = usable.size.y
		target_width = int(floor(float(target_height) * PORTRAIT_ASPECT))

	if target_width <= 0 or target_height <= 0:
		return

	var window_size: Vector2i = Vector2i(target_width, target_height)
	var window: Window = get_tree().root

	window.content_scale_size = DESIGN_SIZE
	window.content_scale_mode = Window.CONTENT_SCALE_MODE_CANVAS_ITEMS
	window.content_scale_aspect = Window.CONTENT_SCALE_ASPECT_KEEP
	window.size = window_size

	var position_x: int = round(float(usable.size.x - window_size.x) / 2.0)
	var position_y: int = round(float(usable.size.y - window_size.y) / 2.0)
	window.position = usable.position + Vector2i(position_x, position_y)

	_print_display_info(screen_size, usable, window_size)


func _print_display_info(
	screen_size: Vector2i,
	usable: Rect2i,
	window_size: Vector2i
) -> void:
	var window: Window = get_tree().root

	print("========== PORTRAIT DISPLAY ==========")
	print("Real screen size : ", screen_size)
	print("Usable screen    : ", usable.size)
	print("Usable position  : ", usable.position)
	print("Game window      : ", window_size)
	print("Content scale    : ", window.content_scale_size)
	print("Root viewport    : ", window.get_viewport().size)
	print("Design canvas    : ", DESIGN_SIZE)
	print("Portrait ratio   : ", PORTRAIT_ASPECT)
	print("Mobile portrait  : ", OS.has_feature("mobile"))
	print("======================================")
