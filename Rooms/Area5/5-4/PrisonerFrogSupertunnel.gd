extends "res://NPC/NPCWalking/NPCWalking.gd"


func initial_dialogue():
	DiagHelper.start_talk(self, "Initial")

	
func enter_maintenance_door():
	$CharacterMover.play("frog_enter_maintenance_door")

func instruction_dialogue():
	DiagHelper.start_talk(self, "Instruction")

func post_dialogue():
	DiagHelper.start_talk(self, "Post")
	$"../../ExitScenePortal/ExitPortalCollisions".set_deferred("disabled", false)
	$"../../ExitScenePortal/ExitDoorLight".energy = 2.02
	
func crumble_noise():
	$"../../CrumbleNoise".playing = true
