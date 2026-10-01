extends Node

# ============================================================
# GLOBAL PORTRAIT DISPLAY POLICY
# ============================================================
#
# 720x1280 is the ORIGINAL DESIGN CANVAS.
#
# The real computer display is used ONLY to calculate
# the desktop game-window size.
#
# The Login scene remains a fixed 720x1280 coordinate system.
# Godot scales the complete canvas uniformly to the window.
# ============================================================

const DESIGN_SIZE: Vector2i = Vector2i(720, 1280)

# Minimum desktop window size.
const MIN_WINDOW_SIZE: Vector2i = Vector2i(360, 640)

# Target percentage of the usable desktop height.
const DESKTOP_HEIGHT_RATIO: float = 0.84

# Portrait ratio: 720 / 1280.
const PORTRAIT_ASPECT: float = (
	float(DESIGN_SIZE.x)
	/ float(DESIGN_SIZE.y)
)


func _ready() -> void:
	RenderingServer.set_default_clear_color(
		Color("#cfe8f7")
	)

	get_window().min_size = MIN_WINDOW_SIZE

	if OS.has_feature("mobile"):
		return

	_fit_desktop_portrait_window()


func _fit_desktop_portrait_window() -> void:
	# --------------------------------------------------------
	# Read the real computer display.
	# --------------------------------------------------------

	var screen_size: Vector2i = (
		DisplayServer.screen_get_size()
	)

	# Usable area excludes taskbar/dock/system UI.
	var usable: Rect2i = (
		DisplayServer.screen_get_usable_rect()
	)

	if screen_size.x <= 0 or screen_size.y <= 0:
		return

	if usable.size.x <= 0 or usable.size.y <= 0:
		return

	# --------------------------------------------------------
	# Calculate target window height from the real display.
	# --------------------------------------------------------

	var target_height: int = int(
		floor(
			float(usable.size.y)
			* DESKTOP_HEIGHT_RATIO
		)
	)

	# Calculate width from the fixed portrait ratio.
	var target_width: int = int(
		floor(
			float(target_height)
			* PORTRAIT_ASPECT
		)
	)

	# --------------------------------------------------------
	# Keep portrait window inside usable screen.
	# --------------------------------------------------------

	if target_width > usable.size.x:
		target_width = usable.size.x

		target_height = int(
			floor(
				float(target_width)
				/ PORTRAIT_ASPECT
			)
		)

	if target_height > usable.size.y:
		target_height = usable.size.y

		target_width = int(
			floor(
				float(target_height)
				* PORTRAIT_ASPECT
			)
		)

	# --------------------------------------------------------
	# Apply minimum size only when the display can support it.
	# --------------------------------------------------------

	if (
		usable.size.x >= MIN_WINDOW_SIZE.x
		and usable.size.y >= MIN_WINDOW_SIZE.y
	):
		if target_width < MIN_WINDOW_SIZE.x:
			target_width = MIN_WINDOW_SIZE.x

			target_height = int(
				floor(
					float(target_width)
					/ PORTRAIT_ASPECT
				)
			)

		if target_height < MIN_WINDOW_SIZE.y:
			target_height = MIN_WINDOW_SIZE.y

			target_width = int(
				floor(
					float(target_height)
					* PORTRAIT_ASPECT
				)
			)

	# --------------------------------------------------------
	# Final safety fit.
	# --------------------------------------------------------

	if target_width > usable.size.x:
		target_width = usable.size.x

		target_height = int(
			floor(
				float(target_width)
				/ PORTRAIT_ASPECT
			)
		)

	if target_height > usable.size.y:
		target_height = usable.size.y

		target_width = int(
			floor(
				float(target_height)
				* PORTRAIT_ASPECT
			)
		)

	var window_size: Vector2i = Vector2i(
		target_width,
		target_height
	)

	# --------------------------------------------------------
	# Only change the window size.
	#
	# Do NOT change the window position.
	# This avoids the Embedded Game warning.
	# --------------------------------------------------------

	get_window().size = window_size

	_print_display_info(
		screen_size,
		usable,
		window_size
	)


func _print_display_info(
	screen_size: Vector2i,
	usable: Rect2i,
	window_size: Vector2i
) -> void:
	print("========== PORTRAIT DISPLAY ==========")
	print("Real screen size : ", screen_size)
	print("Usable screen    : ", usable.size)
	print("Usable position  : ", usable.position)
	print("Game window      : ", window_size)
	print(
		"Design canvas    : ",
		DESIGN_SIZE.x,
		" x ",
		DESIGN_SIZE.y
	)
	print("Portrait ratio   : ", PORTRAIT_ASPECT)
	print("Height ratio     : ", DESKTOP_HEIGHT_RATIO)
	print("======================================")
