extends Control

@onready var decor: Control = $Decor
@onready var center_panel: Panel = $Decor/CenterPanel
@onready var login_button: Button = $Decor/LoginButton
@onready var username_input: LineEdit = $Decor/CenterPanel/Content/UsernameInput
@onready var password_input: LineEdit = $Decor/CenterPanel/Content/PasswordRow/PasswordInput
@onready var password_toggle: TextureButton = $Decor/CenterPanel/Content/PasswordRow/PasswordToggle
@onready var status_label: Label = $Decor/CenterPanel/Content/Status
@onready var remember_me: CheckBox = $Decor/CenterPanel/Content/Links/RememberMe

const EYE_OPEN: String = "res://Background/icon_mat_mk.png"
const EYE_CLOSED: String = "res://Background/icon_khoa.png"

# ============================================================
# ORIGINAL DESIGN CANVAS
# ============================================================
#
# The Login design is created for 720x1280.
#
# This coordinate system is preserved.
# We do NOT calculate a second responsive portrait frame.
#
# Godot's stretch system scales the complete scene uniformly.
# ============================================================

const DESIGN_VIEWPORT_SIZE: Vector2 = Vector2(
	720.0,
	1280.0
)


# ============================================================
# CENTER PANEL
# ============================================================
#
# Original design coordinates:
#
# Left   = 129
# Top    = 290.93376
# Right  = 594
# Bottom = 592.551054
#
# Converted to percentages of 720x1280.
# ============================================================

const CENTER_LEFT: float = (
	129.0 / DESIGN_VIEWPORT_SIZE.x
)

const CENTER_TOP: float = (
	290.93376 / DESIGN_VIEWPORT_SIZE.y
)

const CENTER_RIGHT: float = (
	594.0 / DESIGN_VIEWPORT_SIZE.x
)

const CENTER_BOTTOM: float = (
	592.551054 / DESIGN_VIEWPORT_SIZE.y
)


# ============================================================
# LOGIN BUTTON
# ============================================================
#
# Original design coordinates:
#
# Left   = 136
# Top    = 550
# Right  = 594
# Bottom = 750
# ============================================================

const LOGIN_LEFT: float = (
	136.0 / DESIGN_VIEWPORT_SIZE.x
)

const LOGIN_TOP: float = (
	550.0 / DESIGN_VIEWPORT_SIZE.y
)

const LOGIN_RIGHT: float = (
	594.0 / DESIGN_VIEWPORT_SIZE.x
)

const LOGIN_BOTTOM: float = (
	750.0 / DESIGN_VIEWPORT_SIZE.y
)


func _ready() -> void:
	# Decor is the complete 720x1280 design frame.
	_setup_decor()

	# Keep the main Login elements positioned relative
	# to the original design canvas.
	_setup_login_layout()

	# Password starts hidden.
	password_input.secret = true

	_set_password_toggle_texture(EYE_OPEN)

	# Focus username field.
	username_input.grab_focus()


func _setup_decor() -> void:
	# ========================================================
	# DECOR = COMPLETE DESIGN CANVAS
	# ========================================================
	#
	# No monitor-size calculation here.
	# No viewport-size calculation here.
	# No second portrait frame.
	#
	# Decor simply fills the Login viewport.
	# ========================================================

	decor.anchor_left = 0.0
	decor.anchor_top = 0.0
	decor.anchor_right = 1.0
	decor.anchor_bottom = 1.0

	decor.offset_left = 0.0
	decor.offset_top = 0.0
	decor.offset_right = 0.0
	decor.offset_bottom = 0.0


func _setup_login_layout() -> void:
	# ========================================================
	# CENTER PANEL
	# ========================================================

	center_panel.anchor_left = CENTER_LEFT
	center_panel.anchor_top = CENTER_TOP
	center_panel.anchor_right = CENTER_RIGHT
	center_panel.anchor_bottom = CENTER_BOTTOM

	center_panel.offset_left = 0.0
	center_panel.offset_top = 0.0
	center_panel.offset_right = 0.0
	center_panel.offset_bottom = 0.0


	# ========================================================
	# LOGIN BUTTON
	# ========================================================

	login_button.anchor_left = LOGIN_LEFT
	login_button.anchor_top = LOGIN_TOP
	login_button.anchor_right = LOGIN_RIGHT
	login_button.anchor_bottom = LOGIN_BOTTOM

	login_button.offset_left = 0.0
	login_button.offset_top = 0.0
	login_button.offset_right = 0.0
	login_button.offset_bottom = 0.0


func _set_password_toggle_texture(
	texture_path: String
) -> void:
	var texture: Texture2D = load(texture_path)

	password_toggle.texture_normal = texture
	password_toggle.texture_hover = texture
	password_toggle.texture_pressed = texture


func _on_password_toggle_pressed() -> void:
	password_input.secret = not password_input.secret

	var texture_path: String = (
		EYE_CLOSED
		if password_input.secret
		else EYE_OPEN
	)

	_set_password_toggle_texture(texture_path)

	status_label.text = (
		"Mật khẩu đang được ẩn."
		if password_input.secret
		else "Mật khẩu đang được hiển thị."
	)


func _on_remember_me_toggled(
	pressed: bool
) -> void:
	status_label.text = (
		"Đã chọn ghi nhớ mật khẩu (demo)."
		if pressed
		else "Đã bỏ chọn ghi nhớ mật khẩu (demo)."
	)


func _on_login_pressed() -> void:
	var username: String = (
		username_input.text.strip_edges()
	)

	var password: String = password_input.text

	if username.is_empty() or password.is_empty():
		status_label.text = (
			"Demo: hãy nhập tài khoản và mật khẩu trước."
		)
		return

	status_label.text = (
		"Demo đăng nhập: đã nhận thông tin nhập vào."
	)


func _on_forgot_pressed() -> void:
	status_label.text = (
		"Demo: Quên mật khẩu đã được chọn."
	)


func _on_register_pressed() -> void:
	status_label.text = (
		"Demo: Đăng ký đã được chọn."
	)
