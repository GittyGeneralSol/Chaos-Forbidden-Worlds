extends MovableCharacter
@onready var timer_initial: Timer = $timer_initial
@onready var timer_print: Timer = $timer_print

func _ready() -> void:
    mb_target_position = Vector2(200,85)
    mb_is_moving = false
    hitbox_offset = Vector2(-7,0)
    mb_speed = 100

    movement_completed.connect(_on_movement_completed)
    timer_initial.timeout.connect(_on_timer_initial_timeout)

func _on_timer_initial_timeout() -> void:
    if !mb_is_moving:
        mb_is_moving = true

func _on_movement_completed():
    
    # Behavior:
    
    mb_movement_count += 1
    print("Movement number ", mb_movement_count, " completed!")
    
    # Behavior depends upon the movement count:
    match mb_movement_count:
        1:
            await get_tree().create_timer(1.0).timeout
            current_direction = Direction.DOWN
            await get_tree().create_timer(0.75).timeout
            current_direction = Direction.UP
            await get_tree().create_timer(0.75).timeout
            current_direction = Direction.LEFT
            move_to(Vector2(-400,85))
        2:
            await get_tree().create_timer(1.0).timeout
            current_direction = Direction.RIGHT
            await get_tree().create_timer(0.75).timeout
            current_direction = Direction.DOWN
            await get_tree().create_timer(0.75).timeout
            mb_animation_exception = true
            animated_sprite.play("down_stomp")
            await animated_sprite.animation_finished
            audio.play("overworld/snd_metalstep")
            animated_sprite.play("down_stomp2")
            mb_animation_exception = false
        _:
            pass
            
#func _on_timer_print_timeout() -> void:
    #print("\n\nPlayer y: ", vars.player_position.y)
    #print("\nKnight y: ", position.y)
