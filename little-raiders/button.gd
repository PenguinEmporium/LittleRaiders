extends Node3D
class_name FloorButton

signal on_pressed()
signal on_released()

@export var allow_non_player_press : bool = true

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var interact_area: Area3D = $InteractArea

@onready var button: MeshInstance3D = $Button

var current_tween : Tween
var start_height : float
var target_height : float

func _ready() -> void:
	start_height = button.global_position.y
	target_height = start_height - .25

func press():
	if current_tween != null:
		current_tween.stop()
	var tween = create_tween()
	current_tween = tween
	
	current_tween.tween_property(button,"position:y",target_height,0.4)
	
	on_pressed.emit()

func release():
	if current_tween != null:
		current_tween.stop()
	var tween = create_tween()
	current_tween = tween
	
	current_tween.tween_property(button,"position:y",start_height,0.4)
	
	on_released.emit()

func _on_interact_area_body_entered(body: Node3D) -> void:
	if allow_non_player_press:
		press()
	elif body as BasePlayer:
		press()


func _on_interact_area_body_exited(body: Node3D) -> void:
	
	if body is BasePlayer:
		release()
		return
	
	
	if !interact_area.has_overlapping_bodies():
		release()
	else:
		var bodies := interact_area.get_overlapping_bodies()
		var applicable_body = false
		for ovlap in bodies:
			if body is BasePlayer or allow_non_player_press:
				applicable_body = true
		
		if !applicable_body:
			release()
