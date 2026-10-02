extends Control

@onready var username_input: LineEdit = $CenterPanel/Content/UsernameInput
@onready var password_input: LineEdit = $CenterPanel/Content/PasswordRow/PasswordInput
@onready var password_toggle: TextureButton = $CenterPanel/Content/PasswordRow/PasswordToggle
@onready var status_label: Label = $CenterPanel/Content/Status

const EYE_OPEN := "res://Background/icon_mat_mk.png"
const EYE_CLOSED := "res://Background/icon_khoa.png"

func _ready() -> void:
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

func _on_login_pressed() -> void:
	var username := username_input.text.strip_edges()
	var password := password_input.text

	if username.is_empty() or password.is_empty():
		status_label.text = "Vui lòng nhập đầy đủ tài khoản và mật khẩu."
		return

	status_label.text = "Thông tin đã được nhập. Hệ thống đăng nhập sẽ được kết nối sau."

func _on_forgot_pressed() -> void:
	status_label.text = "Chức năng khôi phục mật khẩu sẽ được bổ sung."

func _on_register_pressed() -> void:
	status_label.text = "Chức năng đăng ký tài khoản sẽ được bổ sung."
