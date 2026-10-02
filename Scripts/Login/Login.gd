extends Control

@onready var username_input: LineEdit = $Background/CenterPanel/Content/UsernameInput
@onready var password_input: LineEdit = $Background/CenterPanel/Content/PasswordRow/PasswordInput
@onready var password_toggle: TextureButton = $Background/CenterPanel/Content/PasswordRow/PasswordToggle
@onready var status_label: Label = $Background/CenterPanel/Content/Status
@onready var remember_me: CheckBox = $Background/CenterPanel/Content/Links/RememberMe

const EYE_OPEN := "res://Background/icon_mat_mk.png"
const EYE_CLOSED := "res://Background/icon_khoa.png"

func _ready() -> void:
    password_input.secret = true
    _set_password_toggle_texture(EYE_OPEN)
    username_input.grab_focus()

func _set_password_toggle_texture(texture_path: String) -> void:
    var texture: Texture2D = load(texture_path)
    password_toggle.texture_normal = texture
    password_toggle.texture_hover = texture
    password_toggle.texture_pressed = texture

func _on_password_toggle_pressed() -> void:
    password_input.secret = not password_input.secret
    var texture_path := EYE_CLOSED if password_input.secret else EYE_OPEN
    _set_password_toggle_texture(texture_path)
    status_label.text = "Mật khẩu đang được ẩn." if password_input.secret else "Mật khẩu đang được hiển thị."

func _on_remember_me_toggled(pressed: bool) -> void:
    status_label.text = "Đã chọn ghi nhớ mật khẩu (demo)." if pressed else "Đã bỏ chọn ghi nhớ mật khẩu (demo)."

func _on_login_pressed() -> void:
    var username := username_input.text.strip_edges()
    var password := password_input.text

    if username.is_empty() or password.is_empty():
        status_label.text = "Demo: hãy nhập tài khoản và mật khẩu trước."
        return

    status_label.text = "Demo đăng nhập: đã nhận thông tin nhập vào."

func _on_forgot_pressed() -> void:
    status_label.text = "Demo: Quên mật khẩu đã được chọn."

func _on_register_pressed() -> void:
    status_label.text = "Demo: Đăng ký đã được chọn."
