extends Node

#GLOBAL
var display : DisplayManager = null
var scene = null
var scene_cam : Camera2D = null
var debug : Debug = null

#BATTLE
var hud_manager : HudManager = null
var dialouge_manager : DialougeManager = null
var player_heart : PlayerHeart = null
var battle_box : BattleBox = null
var main_writer : Writer = null
var attack_manager : AttackManager = null
var enemies : Node2D = null
var black_screen : ColorRect = null

#OVERWORLD
var player_character : Character = null
var player_position : Vector2
var overworld_hud : OverworldHud = null
