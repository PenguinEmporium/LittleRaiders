extends CharacterBody3D
class_name BasePlayer

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

@onready var pivot: Node3D = $Pivot

var attack_timer: float = 0
var combo_margin_timer: float = 0
var attack_cooldown: float = 0
var standard_combo_count: int = 0

enum DamageShape{
	CONE,
	LINE,
	SEMIC,
	CIRCLE
}

var player_attack : Dictionary = {
	"animation":"attack_default",
	"damage":10,
	"shape": DamageShape.CONE,
	"combo_margin": 0.5
	}

func _physics_process(delta: float) -> void:
	if attack_timer > 0:
		attack_timer -= delta
		return
	
	if attack_cooldown > 0:
		attack_cooldown -= delta
	else:
		combo_margin_timer -= delta
		if Input.is_action_just_pressed("Attack"):
			attack(combo_margin_timer>0)
		return
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
		pivot.rotate(Vector3.UP, direction.angle_to(pivot.global_transform.basis.z))
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()

func attack(in_combo_margin:bool = false):
	if in_combo_margin:
		standard_combo_count = 0
	
	match (standard_combo_count):
		0:
			#Setup animation attack data
			#Don't forget setting attack processing
			#Don't forget combo_margin
			standard_combo_count += 1
			pass
		1:
			
			standard_combo_count += 1
			pass
		2:
			
			standard_combo_count = 0
			attack_cooldown = 1
			pass
	
