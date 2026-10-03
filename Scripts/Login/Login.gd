extends Control

@onready var username_input: LineEdit = $LoginArea/A/AContent/UsernameRow/UsernameInput
@onready var password_input: LineEdit = $LoginArea/A/AContent/PasswordRow/PasswordInput
@onready var password_toggle: TextureButton = $LoginArea/A/AContent/PasswordRow/PasswordToggle
@onready var password_slash: Line2D = $LoginArea/A/AContent/PasswordRow/PasswordSlash
@onready var remember_check: CheckBox = $LoginArea/A/AContent/LoginOptionsRow/CheckBox
@onready var forgot_password: Button = $LoginArea/A/AContent/LoginOptionsRow/ForgotPassword
@onready var register_button: Button = $LoginArea/A/AContent/LoginOptionsRow/Register
@onready var login_button: TextureButton = $LoginArea/A/BContent/LoginButton

const EYE_TEXTURE: Texture2D = preload("res://Background/icon_mat_mk.png")


func _ready() -> void:
	_setup_input_alignment()
	_setup_password()
	_setup_buttons()
	_connect_signals()

	print("=== LOGIN SCREEN ===")
	print("Design: 1280 x 2340")
	print("Tên đăng nhập: SẴN SÀNG")
	print("Mật khẩu: SẴN SÀNG")
	print("Mật khẩu mặc định: ẨN")
	print("Ghi nhớ: TẮT")
	print("Quên mật khẩu: SẴN SÀNG")
	print("Đăng ký: SẴN SÀNG")
	print("Đăng nhập: SẴN SÀNG")
	print("====================")

	username_input.grab_focus()


func _setup_input_alignment() -> void:
	username_input.alignment = HORIZONTAL_ALIGNMENT_LEFT
	password_input.alignment = HORIZONTAL_ALIGNMENT_LEFT


func _setup_password() -> void:
	password_input.secret = true
	password_toggle.self_modulate.a = 0.45
	password_slash.visible = true

	password_toggle.texture_normal = EYE_TEXTURE
	password_toggle.texture_hover = EYE_TEXTURE
	password_toggle.texture_pressed = EYE_TEXTURE


func _setup_buttons() -> void:
	var login_text: Node = login_button.get_node_or_null("LoginButtonText")

	if login_text != null and login_text is Control:
		var login_control: Control = login_text as Control
		login_control.mouse_filter = Control.MOUSE_FILTER_IGNORE


func _connect_signals() -> void:
	if not password_toggle.pressed.is_connected(_on_password_toggle_pressed):
		password_toggle.pressed.connect(_on_password_toggle_pressed)

	if not remember_check.toggled.is_connected(_on_remember_check_toggled):
		remember_check.toggled.connect(_on_remember_check_toggled)

	if not forgot_password.pressed.is_connected(_on_forgot_password_pressed):
		forgot_password.pressed.connect(_on_forgot_password_pressed)

	if not register_button.pressed.is_connected(_on_register_pressed):
		register_button.pressed.connect(_on_register_pressed)

	if not login_button.pressed.is_connected(_on_login_button_pressed):
		login_button.pressed.connect(_on_login_button_pressed)


func _toggle_password_visibility() -> void:
	password_input.secret = not password_input.secret

	if password_input.secret:
		password_toggle.self_modulate.a = 0.45
		password_slash.visible = true
		print("Nhấp hiện mật khẩu: ẨN")
	else:
		password_toggle.self_modulate.a = 1.0
		password_slash.visible = false
		print("Nhấp hiện mật khẩu: HIỆN")


func _on_password_toggle_pressed() -> void:
	_toggle_password_visibility()


func _on_remember_check_toggled(pressed: bool) -> void:
	if pressed:
		print("Ghi nhớ: ĐÃ TICK")
	else:
		print("Ghi nhớ: ĐÃ BỎ TICK")


func _on_forgot_password_pressed() -> void:
	print("Quên mật khẩu: ĐÃ NHẤP")
	print("Đường dẫn: Forgot Password")


func _on_register_pressed() -> void:
	print("Đăng ký: ĐÃ NHẤP")
	print("Đường dẫn: Register")


func _on_login_button_pressed() -> void:
	var username: String = username_input.text.strip_edges()
	var password: String = password_input.text

	print("Đăng nhập: ĐÃ NHẤP")
	print("Tên đăng nhập: ", username)
	print("Mật khẩu: ", password)

	if username.is_empty():
		print("Đăng nhập: THIẾU TÊN ĐĂNG NHẬP")
		username_input.grab_focus()
		return

	if password.is_empty():
		print("Đăng nhập: THIẾU MẬT KHẨU")
		password_input.grab_focus()
		return

	print("Đăng nhập: ĐỦ THÔNG TIN")
