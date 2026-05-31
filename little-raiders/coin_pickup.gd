extends Node3D

@onready var ring_mesh: MeshInstance3D = $RingMesh

@export var rotate_speed: float = 5

var collected : bool = false

var height_to_rise : float = 3

const ROSE_GOLD = preload("uid://dn401v8c8vybv")
const current_color : Color = ROSE_GOLD.albedo_color

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ring_mesh.set_surface_override_material(0,ROSE_GOLD.duplicate())

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if collected:
		return
	
	ring_mesh.rotate(Vector3.UP,rotate_speed * delta)

func remove_ring():
	var current_height = global_position.y
	var current_y_rotation = global_rotation.y
	var current_material : StandardMaterial3D = ring_mesh.get_surface_override_material(0)
	var new_color =  Color(current_color)
	new_color.a = 0
	
	var bounce_tween = create_tween()
	var spin_tween = create_tween()
	var disappear_tween = create_tween()
	bounce_tween.tween_property(ring_mesh,"position:y",current_height+height_to_rise,1.5).set_trans(Tween.TRANS_EXPO)
	spin_tween.tween_property(ring_mesh,"rotation:y",current_y_rotation+820,1.5).set_trans(Tween.TRANS_ELASTIC)
	disappear_tween.tween_property(current_material,"albedo_color",new_color,1.2).set_trans(Tween.TRANS_EXPO)
	await disappear_tween.finished
	
	ring_mesh.hide()

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is CharacterBody3D:
		if !collected:
			collected = true
			remove_ring()
	pass # Replace with function body.
