extends Attack
@onready var dialouge_manager: Node2D = $dialouge_manager

var a_vars : vars = vars

func _init():
    frames = 250

func pre_attack():
    a_vars.player_heart.heart_mode = PlayerHeart.e_heart_mode.red
    a_vars.battle_box.set_box_size([244,250,399,390])
    await get_tree().process_frame
    a_vars.player_heart.visible = true
    a_vars.player_heart.global_position = Vector2(321, 375)

func start_attack():
    vars.player_heart.input_enabled = true
    attack_started = true
#	a_vars.attack_manager.gaster_blaster(0,Vector2(-100,-100),Vector2(150,100),0,Vector2(1,1),0,0,false)
#	a_vars.attack_manager.gaster_blaster(0,Vector2(-100,-100),Vector2(180,100),0,Vector2(1,1),0,0,false)
#	a_vars.attack_manager.gaster_blaster(0,Vector2(-100,-100),Vector2(210,100),0,Vector2(1,1),0,0,false)
    bones_part_one()

func bones_part_one():
    a_vars.attack_manager.bone(0,Vector2(150,300),1,0,120,0,50,0,true)
    var i = randi_range(-4,4)
    a_vars.attack_manager.gaster_blaster(0,Vector2(-100,-100),Vector2(150,100),(i * -5) - 40,Vector2(1,1),0,0,false)
    await get_tree().create_timer(1.5).timeout
    await get_tree().root.find_child("dialouge_manager",true,false).ending_remark()
    end_attack()
    
func end_attack():
    vars.hud_manager.reset()
    attack_finished.emit()
    queue_free()
