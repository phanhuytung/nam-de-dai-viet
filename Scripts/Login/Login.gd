extends Control

@onready var username_input: LineEdit = $Background/CenterPanel/Content/UsernameInput
@onready var password_input: LineEdit = $Background/CenterPanel/Content/PasswordRow/PasswordInput
@onready var password_toggle: TextureButton = $Background/CenterPanel/Content/PasswordRow/PasswordInput/PasswordToggle
@onready var status_label: Label = $Background/CenterPanel/Content/Status
@onready var remember_me: CheckBox = $Background/CenterPanel/Content/RememberMe

const EYE_OPEN := "res://Background/icon_mat_mk.png"
const EYE_CLOSED := "res://Background/icon_khoa.png"
const LOGIN_DATA_PATH := "user://login_data.cfg"
const LOGIN_DATA_KEY := "NamDeDaiViet_LocalLogin_2026"

func _ready() -> void:
	_load_saved_login()
	username_input.grab_focus()
	password_input.secret = true
	password_toggle.texture_normal = load(EYE_OPEN)
	password_toggle.texture_hover = load(EYE_OPEN)
	password_toggle.texture_pressed = load(EYE_OPEN)

func _on_password_toggle_pressed() -> void:
	password_input.secret = not password_input.secret
	var texture_path := EYE_CLOSED if password_input.secret else EYE_OPEN
	var texture: Texture2D = load(texture_path)
	password_toggle.texture_normal = texture
	password_toggle.texture_hover = texture
	password_toggle.texture_pressed = texture

func _load_saved_login() -> void:
	var config := ConfigFile.new()
	if config.load_encrypted_pass(LOGIN_DATA_PATH, LOGIN_DATA_KEY) != OK:
		return

	username_input.text = str(config.get_value("login", "username", ""))
	password_input.text = str(config.get_value("login", "password", ""))
	remember_me.button_pressed = not username_input.text.is_empty() or not password_input.text.is_empty()

func _save_login() -> void:
	var config := ConfigFile.new()
	config.set_value("login", "username", username_input.text.strip_edges())
	config.set_value("login", "password", password_input.text)
	config.save_encrypted_pass(LOGIN_DATA_PATH, LOGIN_DATA_KEY)

func _clear_saved_login() -> void:
	DirAccess.remove_absolute(ProjectSettings.globalize_path(LOGIN_DATA_PATH))

func _on_remember_me_toggled(pressed: bool) -> void:
	if pressed:
		return
	_clear_saved_login()

func _on_login_pressed() -> void:
	var username := username_input.text.strip_edges()
	var password := password_input.text

	if username.is_empty() or password.is_empty():
		status_label.text = "Vui lòng nhập đầy đủ tài khoản và mật khẩu."
		return

	if remember_me.button_pressed:
		_save_login()
	else:
		_clear_saved_login()

	status_label.text = "Thông tin đã được nhập. Hệ thống đăng nhập sẽ được kết nối sau."

func _on_forgot_pressed() -> void:
	status_label.text = "Chức năng khôi phục mật khẩu sẽ được bổ sung."

func _on_register_pressed() -> void:
	status_label.text = "Chức năng đăng ký tài khoản sẽ được bổ sung."
