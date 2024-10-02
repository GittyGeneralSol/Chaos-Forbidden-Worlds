class_name MovableCharacter
extends CharacterBody2D

signal movement_completed

@export var mb_speed = 100
@export var hitbox_offset = Vector2.ZERO

var mb_target_position = Vector2.ZERO
var mb_is_moving = false
var mb_has_emitted_completion = false
var mb_movement_count := 0 # Used to count the number of movements
var mb_animation_exception := false

enum Direction { UP, DOWN, LEFT, RIGHT }
var current_direction = Direction.DOWN

@onready var animated_sprite = $AnimatedSprite2D
@onready var hitbox = $CollisionShape2D

# Executed Every frame.

func _physics_process(delta):
    if mb_is_moving:
        var direction = (mb_target_position - global_position).normalized()
        var desired_velocity = direction * mb_speed
        velocity = velocity.move_toward(desired_velocity, mb_speed * delta)
        move_and_slide()

        update_direction()

        if global_position.distance_to(mb_target_position) < 5:
            if mb_is_moving:
                mb_is_moving = false
                velocity = Vector2.ZERO # So char doesnt continue moving with leftover velocity in new movement
                
                if mb_has_emitted_completion == false:
                    movement_completed.emit()
                    mb_has_emitted_completion = true

    update_animation()
    update_hitbox_position()
    z_ordering()

func move_to(new_position):
    mb_target_position = new_position
    mb_is_moving = true
    mb_has_emitted_completion = false

func update_direction():
    var angle = velocity.angle()
    if angle < -3*PI/4 or angle > 3*PI/4:
        current_direction = Direction.LEFT
    elif angle < -PI/4:
        current_direction = Direction.UP
    elif angle < PI/4:
        current_direction = Direction.RIGHT
    else:
        current_direction = Direction.DOWN

func update_animation():
    var anim_prefix = "idle_" if not mb_is_moving else "walk_"
    var anim_suffix = ""

    match current_direction:
        Direction.UP:
            anim_suffix = "up"
        Direction.DOWN:
            anim_suffix = "down"
        Direction.LEFT:
            anim_suffix = "left"
        Direction.RIGHT:
            anim_suffix = "right"
    
    if not mb_animation_exception:
        animated_sprite.play(anim_prefix + anim_suffix)

func update_hitbox_position():
    match current_direction:
        Direction.UP:
            hitbox.position = Vector2(0, hitbox_offset.y)
        Direction.DOWN:
            hitbox.position = Vector2(0, -hitbox_offset.y)
        Direction.LEFT:
            hitbox.position = Vector2(-hitbox_offset.x, 0)
        Direction.RIGHT:
            hitbox.position = Vector2(hitbox_offset.x, 0)

func set_hitbox_offset(offset: Vector2):
    hitbox_offset = offset

# Important for determining whether to animate over or below a character (mostly the player)

func z_ordering():
    animated_sprite.z_index = 0 
    if vars.player_position.y >= position.y:
       animated_sprite.z_index = 0
    elif vars.player_position.y < position.y:
       animated_sprite.z_index = 1
