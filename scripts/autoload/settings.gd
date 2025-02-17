extends Node

var player_save : PlayerSave = null
var death_position : Vector2 = Vector2.ZERO
var zoomed_in := true :
    set(value):
        zoomed_in = value
        change_zoom()
var debug_enabled := OS.is_debug_build() #Disable in public builds

func _ready():
    start()
    #load_game()
    reset_game()

func start() -> void:
    RenderingServer.set_default_clear_color(Color.BLACK)
    DisplayServer.window_set_mode(0)
    get_viewport().size = Vector2(640,480)

func reset_game():
    player_save = PlayerSave.new()
    save_game()

func load_game():
    if(ResourceLoader.exists("user://saved.tres")):
        player_save = ResourceLoader.load("user://saved.tres").duplicate()
    else:
        reset_game()

func save_game():
    ResourceSaver.save(player_save, "user://saved.tres")

func _process(delta):
    if(Input.is_action_just_pressed("restart")):
        if(vars.scene):
            audio.stop_music()
            audio.stop_all_sounds()
            vars.scene.queue_free()
            await get_tree().process_frame
            load_game()
            vars.display.change_scene(vars.display.starting_scene)
    if Input.is_action_just_pressed("fullscreen") && !Input.is_action_pressed("alt"):
        toggle_resolution()
    if Input.is_action_just_pressed("zoom"):
        zoomed_in = !zoomed_in
    if(player_save != null):
        player_save.data.time += delta

func toggle_resolution():
    match(DisplayServer.window_get_mode()):
        0:
            DisplayServer.window_set_mode(3)
            get_viewport().size = Vector2(1920,1080)
            DisplayServer.window_set_position(Vector2(Vector2(DisplayServer.screen_get_size() / 2) - Vector2(get_viewport().size / 2)))
        3:
            DisplayServer.window_set_mode(0)
            get_viewport().size = Vector2(640,480)
    change_zoom()

func change_zoom():
    if(zoomed_in):
        vars.display.border.visible = false
        match(DisplayServer.window_get_mode()):
            0:
                vars.display.camera.zoom = Vector2(1,1)
                get_viewport().size = Vector2(640,480)
            3:
                vars.display.camera.zoom = Vector2(2.25,2.25)
    else:
        vars.display.border.visible = true
        match(DisplayServer.window_get_mode()):
            0:
                vars.display.camera.zoom = Vector2(1,1)
                get_viewport().size = Vector2(960,540)
            3:
                vars.display.camera.zoom = Vector2(2,2)
