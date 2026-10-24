extends RigidBody2D

const speed_break_point = 300
const bump_force_y = 200
const bump_force_x = 100
const fall_limit = 10

var last_collider
@onready var collision_shape = $CollisionShape2D
@onready var raycast = $RayCast2D

var fall_y_position

@export var speed = 200
var direction = -1
var should_switch_direction = true
var is_going_down = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if is_going_down:
		var current_pos_y = position.y
		if current_pos_y - fall_y_position > fall_limit:
			is_going_down = false
			set_collision_mask_value(4, true)
		return
	
	if raycast.is_colliding():
		var collider = raycast.get_collider()
		if collider.is_in_group("Ladders") and collider != last_collider:
			fall_down()
			last_collider = collider
	linear_velocity.x = speed * direction * delta

func fall_down():
	if is_going_down:
		return
	fall_y_position = position.y
	set_collision_mask_value(4, false)
	direction = direction * -1
	is_going_down = true
	


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "meriu":
		body.Die()
