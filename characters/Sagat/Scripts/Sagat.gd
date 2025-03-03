extends CharacterBody2D


const SPEED = 300.0


# Jump


const JUMP_VELOCITY = -600.0


var is_crouching: bool = false
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var attack_cooldown_timer = 0.0
var attack_cooldown_duration = 3 # Cooldown duration for the attack animation in seconds
var can_attack = true # Variable to check if the player can attack
var is_attacking = false
var is_jumping = false
var is_walking = false
@onready  var _animation_player = $AnimatedSprite2D
func _ready():
	_animation_player.play("Hidle")
	
	
func _physics_process(delta):
	# Add the gravity.

	if not is_on_floor():
		velocity.y += gravity * delta
		
	if is_on_floor():
		is_jumping = false

		
	# Handle Jump.
	if Input.is_action_just_pressed("ui_up") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		is_jumping = true

	$Area2D/Punch.set_disabled(false)
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
		is_walking = true
		print("Bouge")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		is_walking = false
	if Input.is_action_just_pressed("ui_down") :
		velocity.x = 0
	move_and_slide()

func _process(delta):
	if can_attack  and Input.is_action_just_pressed("L.Punch") and attack_cooldown_timer <= 0.0:
		_animation_player.play("L.punch")
		is_attacking = true
		can_attack = false
	
	if Input.is_action_pressed("ui_up"):
		if _animation_player.is_playing() and is_jumping:
			_animation_player.play("Jump")
			
	elif Input.is_action_pressed("ui_right") or Input.is_action_pressed("ui_left"):
		_animation_player.play("Walk")
		
	
	if !can_attack and attack_cooldown_timer <= 0.0:
		print("can attack !")
		can_attack = true
	if !_animation_player.is_playing():
		_animation_player.play("Hidle")
		

