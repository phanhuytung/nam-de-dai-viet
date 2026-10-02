extends Control

@onready var center_panel: Panel = $Background/CenterPanel
@onready var username_input: LineEdit = $Background/CenterPanel/Content/UsernameInput
@onready var password_input: LineEdit = $Background/CenterPanel/Content/PasswordRow/PasswordInput
@onready var password_toggle: TextureButton = $Background/CenterPanel/Content/PasswordRow/PasswordToggle
@onready var status_label: Label = $Background/CenterPanel/Content/Status
@onready var remember_me: CheckBox = $Background/CenterPanel/Content/Links/RememberMe

const EYE_OPEN := "res://Background/icon_mat_mk.png"
const EYE_CLOSED := "res://Background/icon_khoa.png"

# These values preserve the positions established in the 2D editor at 720x1280.
const DESIGN_PANEL_CENTER := Vector2(0.51180556, 0.3050359)
const DESIGN_PANEL_SIZE := Vector2(511.0, 293.0)
const MIN_PANEL_WIDTH := 300.0
const COMPACT_PANEL_HEIGHT := 330.0

func _ready() -> void:
    get_viewport().size_changed.connect(_on_viewport_resized)
    _apply_responsive_layout()

    password_input.secret = true
    _set_password_toggle_texture(EYE_OPEN)
    username_input.grab_focus()

func _on_viewport_resized() -> void:
    _apply_responsive_layout()

func _apply_responsive_layout() -> void:
    var viewport_size := get_viewport_rect().size
    var panel_width: float = clampf(
        viewport_size.x * (DESIGN_PANEL_SIZE.x / 720.0),
        MIN_PANEL_WIDTH,
        DESIGN_PANEL_SIZE.x
    )
    var panel_height := DESIGN_PANEL_SIZE.y
    if panel_width < 430.0:
        panel_height = COMPACT_PANEL_HEIGHT

    center_panel.anchor_left = DESIGN_PANEL_CENTER.x
    center_panel.anchor_right = DESIGN_PANEL_CENTER.x
    center_panel.anchor_top = DESIGN_PANEL_CENTER.y
    center_panel.anchor_bottom = DESIGN_PANEL_CENTER.y
    center_panel.offset_left = -panel_width * 0.5
    center_panel.offset_right = panel_width * 0.5
    center_panel.offset_top = -panel_height * 0.5
    center_panel.offset_bottom = panel_height * 0.5

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
