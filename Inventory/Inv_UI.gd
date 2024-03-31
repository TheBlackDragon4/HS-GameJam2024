extends Control

@onready var inv: Inv = preload("res://Inventory/player_inventory.tres")
@onready var craft: Inv = preload("res://Inventory/crafting/player_crafting_inventory.tres")
@onready var slots: Array = $NinePatchRect/GridContainer.get_children()
@onready var craft_slots: Array = $NinePatchCrafting/GridContainer.get_children()

var inv_open = false
@onready var selectedSlot = $NinePatchRect/GridContainer/Inv_UI_Slot1
@onready var selectedSlotCrafting = $NinePatchCrafting/GridContainer/Craft_UI_Slot1
var slotArray = []
var craftArray = []
var currentPos = 0
var craftingPos = -1
var selectMode = "inv" # inv or craft


@onready var dialog = $DeleteDialog
@onready var equipButton = $DeleteDialog/HBoxContainer/Equip
@onready var deleteButton = $DeleteDialog/HBoxContainer/Delete
@onready var cancelButton = $DeleteDialog/HBoxContainer/Cancel

@onready var craftDialog = $CraftingDialog
@onready var craftButton = $CraftingDialog/VBoxContainer/Craft
@onready var removeButton = $CraftingDialog/VBoxContainer/Remove
@onready var insertButton = $CraftingDialog/VBoxContainer/Insert

@onready var weapon = slots[0]

func _ready():
	update_slots()
	close()
	for slot in $NinePatchRect/GridContainer.get_children():
		slotArray.append(slot)
	for slot in $NinePatchCrafting/GridContainer.get_children():
		craftArray.append(slot)
	Global.weapon = weapon

func update_slots():
	for i in range(min(inv.items.size(), slots.size())):
		slots[i].update(inv.items[i])
	for i in range(min(craft.items.size(), craft_slots.size())):
		craft_slots[i].update(craft.items[i])

func _process(_delta):
	if Input.is_action_just_pressed("Inventory") and dialog.visible:
			equipButton.emit_signal("pressed")
			dialog.visible = false
	if Input.is_action_just_pressed("menu_first") and dialog.visible:
			deleteButton.emit_signal("pressed")
			dialog.visible = false
	if Input.is_action_just_pressed("menu_second") and dialog.visible:
			cancelButton.emit_signal("pressed")
			dialog.visible = false


func _input(_event):
	if Input.is_action_just_pressed("open_door") and craftDialog.visible:
			craftButton.emit_signal("pressed")
			craftDialog.visible = false
	if Input.is_action_just_pressed("crafting_insert") and craftDialog.visible:
			insertButton.emit_signal("pressed")
			craftDialog.visible = false
	if Input.is_action_just_pressed("delete_item") and craftDialog.visible:
			removeButton.emit_signal("pressed")
			craftDialog.visible = false

	if Input.is_action_just_pressed("interact"):
		update_slots()
	if Input.is_action_just_pressed("Inventory"):
		if inv_open:
			close()
		else:
			update_slots()
			open()
	if inv_open:
		var action = ""
		if Input.is_action_just_pressed("left"):
			action = "left"
		if Input.is_action_just_pressed("right"):
			action = "right"
		if Input.is_action_just_pressed("jump"):
			action = "jump"
		if Input.is_action_just_pressed("interact"):
			action = "interact"
		
		
		if selectMode == "inv":
			selectedSlot.get_node("Sprite2D").animation = "default"
		else:
			selectedSlotCrafting.get_node("Sprite2D").animation = "default"
		
		match action:
			"left":
				if selectMode == "inv":
					match currentPos:
						0:
							currentPos = -1
							craftingPos = 2
							selectMode = "craft"
						4:
							currentPos = -1
							craftingPos = 5
							selectMode = "craft"
						8:
							currentPos = -1
							craftingPos = 8
							selectMode = "craft"
						_:
							if currentPos != -1:
								currentPos = currentPos-1
								selectMode = "inv"
				else:
					match craftingPos:
						0:
							currentPos = 3
							craftingPos = -1
							selectMode = "inv"
						3:
							currentPos = 7
							craftingPos = -1
							selectMode = "inv"
						6:
							currentPos = 11
							craftingPos = -1
							selectMode = "inv"
						_:
							if craftingPos != -1:
								craftingPos = craftingPos-1
								selectMode = "craft"
							
			"right":
				if selectMode == "inv":
					match currentPos:
						3:
							currentPos = -1
							craftingPos = 0
							selectMode = "craft"
						7:
							currentPos = -1
							craftingPos = 3
							selectMode = "craft"
						11:
							currentPos = -1
							craftingPos = 6
							selectMode = "craft"
						_:
							if currentPos != -1:
								currentPos = currentPos+1
								selectMode = "inv"
				else:
					match craftingPos:
						2:
							currentPos = 0
							craftingPos = -1
							selectMode = "inv"
						5:
							currentPos = 4
							craftingPos = -1
							selectMode = "inv"
						8:
							currentPos = 8
							craftingPos = -1
							selectMode = "inv"
						_:
							if craftingPos != -1:
								craftingPos = craftingPos+1
								selectMode = "craft"
							
			"jump":
				if selectMode == "inv":
					match currentPos:
						0:
							currentPos = 8
							craftingPos = -1
							selectMode = "inv"
						1:
							currentPos = 9
							craftingPos = -1
							selectMode = "inv"
						2:
							currentPos = 10
							craftingPos = -1
							selectMode = "inv"
						3:
							currentPos = 11
							craftingPos = -1
							selectMode = "inv"
						_:
							if currentPos != -1:
								currentPos = currentPos-4
								selectMode = "inv"
				else:
					match craftingPos:
						0:
							currentPos = -1
							craftingPos = 6
							selectMode = "craft"
						1:
							currentPos = -1
							craftingPos = 7
							selectMode = "craft"
						2:
							currentPos = -1
							craftingPos = 8
							selectMode = "craft"
						_:
							if craftingPos != -1:
								craftingPos = craftingPos-3
								selectMode = "craft"
								
			"interact":
				if selectMode == "inv":
					match currentPos:
						8:
							currentPos = 0
							craftingPos = -1
							selectMode = "inv"
						9:
							currentPos = 1
							craftingPos = -1
							selectMode = "inv"
						10:
							currentPos = 2
							craftingPos = -1
							selectMode = "inv"
						11:
							currentPos = 3
							craftingPos = -1
							selectMode = "inv"
						_:
							if currentPos != -1:
								currentPos = currentPos+4
								selectMode = "inv"
				else:
					match craftingPos:
						6:
							currentPos = -1
							craftingPos = 0
							selectMode = "craft"
						7:
							currentPos = -1
							craftingPos = 1
							selectMode = "craft"
						8:
							currentPos = -1
							craftingPos = 2
							selectMode = "craft"
						_:
							if craftingPos != -1:
								craftingPos = craftingPos+3
								selectMode = "craft"
					
		if selectMode == "inv":
			selectedSlot = slotArray[currentPos]
			selectedSlot.get_node("Sprite2D").animation = "selected"
		else:
			selectedSlotCrafting = craftArray[craftingPos]
			selectedSlotCrafting.get_node("Sprite2D").animation = "selected"
		
		if Input.is_action_just_pressed("delete_item"):
			if inv.items[currentPos] != null and currentPos != 0:
				dialog.visible = true
		if Input.is_action_just_pressed("open_door"):
			if selectMode == "craft":
				craftDialog.visible = true

func close():
	get_parent().isFreezed = false
	inv_open = false
	visible = false
	dialog.visible = false
	craftDialog.visible = false

func open():
	get_parent().isFreezed = true
	inv_open = true
	visible = true
	selectedSlot.get_node("Sprite2D").animation = "selected"

func _on_delete_pressed():
	inv.items[currentPos] = null
	update_slots()

func _on_equip_pressed():
	var prevEquipedItem = inv.items[0]
	inv.items[0] = inv.items[currentPos]
	inv.items[currentPos] = prevEquipedItem
	Global.weapon = inv.items[0]
	update_slots()

func _on_craft_pressed():
	pass # TODO Replace with function body.


func _on_remove_pressed():
	pass # Replace with function body.


func _on_insert_pressed():
	#craftDialog.visible = true
	#var inputField = selectedSlotCrafting
	
	var inputField = craft.items[craftingPos]
	var selectedCraftPos = craftingPos
	inputField.get_node("Sprite2D").animation = "crafting"
	
	currentPos = 0
	craftingPos = -1
	if Input.is_action_just_pressed("crafting_insert"):
		craft.items[selectedCraftPos] = inv.items[currentPos]
		inv.items[currentPos] = null
		#inputField = inv.items[currentPos]
		currentPos = -1
		craftingPos = selectedCraftPos
		update_slots()
		#selectedSlotCrafting = inputField
	

