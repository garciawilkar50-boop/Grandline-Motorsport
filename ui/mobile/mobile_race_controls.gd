extends CanvasLayer

## On-screen controls for single-player mobile races. Buttons are independent,
## so steering, throttle and brake can be held simultaneously.
signal pause_requested
signal reset_requested

const PANEL := Color(0.035, 0.045, 0.06, 0.72)
const PANEL_ACTIVE := Color(0.89, 0.12, 0.19, 0.94)
const TEXT := Color(0.96, 0.97, 0.99, 1.0)

var root: Control
var left_button: Button
var right_button: Button
var throttle_button: Button
var brake_button: Button
var handbrake_button: Button
var pause_button: Button
var reset_button: Button

func _ready() -> void:
	layer = 20
	root = Control.new()
	root.name = "TouchControls"
	root.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	root.mouse_filter = Control.MOUSE_FILTER_PASS
	add_child(root)
	_build_controls()
	get_viewport().size_changed.connect(_layout)
	_layout()
	visible = OS.has_feature("mobile")

func _build_controls() -> void:
	left_button = _make_hold_button("◀", "Steer left")
	right_button = _make_hold_button("▶", "Steer right")
	throttle_button = _make_hold_button("ACCELERATE", "Accelerate")
	brake_button = _make_hold_button("BRAKE", "Brake")
	handbrake_button = _make_hold_button("HANDBRAKE", "Handbrake")
	pause_button = _make_action_button("Ⅱ", "Pause race")
	reset_button = _make_action_button("RESET", "Reset car")

	left_button.button_down.connect(func(): InputManager.set_touch_steering(-1.0))
	left_button.button_up.connect(_release_steering)
	right_button.button_down.connect(func(): InputManager.set_touch_steering(1.0))
	right_button.button_up.connect(_release_steering)
	throttle_button.button_down.connect(func(): InputManager.set_touch_throttle(1.0))
	throttle_button.button_up.connect(func(): InputManager.set_touch_throttle(0.0))
	brake_button.button_down.connect(func(): InputManager.set_touch_brake(1.0))
	brake_button.button_up.connect(func(): InputManager.set_touch_brake(0.0))
	handbrake_button.button_down.connect(func(): InputManager.set_touch_handbrake(true))
	handbrake_button.button_up.connect(func(): InputManager.set_touch_handbrake(false))
	pause_button.pressed.connect(func(): pause_requested.emit())
	reset_button.pressed.connect(func(): reset_requested.emit())

func _make_hold_button(caption: String, description: String) -> Button:
	var button := Button.new()
	button.text = caption
	button.tooltip_text = description
	button.focus_mode = Control.FOCUS_NONE
	button.add_theme_font_size_override("font_size", 18 if caption.length() < 5 else 12)
	button.add_theme_color_override("font_color", TEXT)
	button.add_theme_stylebox_override("normal", _style(PANEL))
	button.add_theme_stylebox_override("hover", _style(Color(0.13, 0.15, 0.19, 0.9)))
	button.add_theme_stylebox_override("pressed", _style(PANEL_ACTIVE))
	root.add_child(button)
	return button

func _make_action_button(caption: String, description: String) -> Button:
	return _make_hold_button(caption, description)

func _style(color: Color) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = color
	style.border_color = Color(1.0, 1.0, 1.0, 0.18)
	style.set_border_width_all(1)
	style.set_corner_radius_all(14)
	style.content_margin_left = 8
	style.content_margin_right = 8
	style.content_margin_top = 6
	style.content_margin_bottom = 6
	return style

func _layout() -> void:
	if not is_instance_valid(root):
		return
	var size := get_viewport().get_visible_rect().size
	var w: float = size.x
	var h: float = size.y
	var unit: float = clampf(minf(w, h) * 0.15, 64.0, 100.0)
	var margin: float = clampf(w * 0.025, 14.0, 30.0)
	left_button.position = Vector2(margin, h - unit * 1.15 - margin)
	left_button.size = Vector2(unit, unit)
	right_button.position = Vector2(margin + unit + 10.0, h - unit * 1.15 - margin)
	right_button.size = Vector2(unit, unit)
	throttle_button.size = Vector2(unit * 1.65, unit * 1.12)
	throttle_button.position = Vector2(w - throttle_button.size.x - margin, h - throttle_button.size.y - margin)
	brake_button.size = Vector2(unit * 1.18, unit * 0.9)
	brake_button.position = Vector2(throttle_button.position.x - brake_button.size.x - 10.0, h - brake_button.size.y - margin)
	handbrake_button.size = Vector2(unit * 1.18, unit * 0.62)
	handbrake_button.position = Vector2(brake_button.position.x, brake_button.position.y - handbrake_button.size.y - 8.0)
	pause_button.size = Vector2(unit * 0.56, unit * 0.48)
	pause_button.position = Vector2(w - pause_button.size.x - margin, margin)
	reset_button.size = Vector2(unit * 1.0, unit * 0.48)
	reset_button.position = Vector2(margin, margin)

func _release_steering() -> void:
	# Button-up events only clear steering when neither direction remains held.
	if not left_button.button_pressed and not right_button.button_pressed:
		InputManager.set_touch_steering(0.0)

func _notification(what: int) -> void:
	if what == NOTIFICATION_APPLICATION_FOCUS_OUT or what == NOTIFICATION_APPLICATION_PAUSED:
		if is_instance_valid(InputManager):
			InputManager.clear_touch_inputs()

func _exit_tree() -> void:
	if is_instance_valid(InputManager):
		InputManager.clear_touch_inputs()
