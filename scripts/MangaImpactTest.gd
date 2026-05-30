extends Node2D

@onready var impact_rect: ColorRect = $ImpactLayer/MangaImpactRect
@onready var hint_label: Label = $UILayer/HintLabel

func _ready() -> void:
	var mat := impact_rect.material as ShaderMaterial
	mat.set_shader_parameter("impact", 0.0)

	hint_label.text = "Press SPACE or click anywhere to trigger Manga Impact"

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.pressed and not event.echo and event.keycode == KEY_SPACE:
			var center := get_viewport().get_visible_rect().size * 0.5
			play_manga_impact(center)

	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			play_manga_impact(event.position)

func play_manga_impact(screen_position: Vector2) -> void:
	var mat := impact_rect.material as ShaderMaterial
	var viewport_size := get_viewport().get_visible_rect().size
	var center_uv := screen_position / viewport_size

	mat.set_shader_parameter("impact_center", center_uv)
	mat.set_shader_parameter("impact", 1.0)

	var tween := create_tween()
	tween.tween_method(
		func(v: float) -> void:
			mat.set_shader_parameter("impact", v),
		1.0,
		0.0,
		1.0
	).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
