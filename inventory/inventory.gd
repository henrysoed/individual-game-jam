extends Resource

class_name Inventory

signal updated

@export var slots: Array[InventorySlot]

func insert(item: InventoryItem):
    # First, try to find existing stacks of the same item that aren't full
    for slot in slots:
        if slot.item == item and slot.amount < item.maxAmountPrStack:
            var spaceInSlot = item.maxAmountPrStack - slot.amount
            slot.amount += 1
            updated.emit()
            return
    
    # If we can't find a non-full stack, find the first empty slot
    for i in range(slots.size()):
        if !slots[i].item:
            slots[i].item = item
            slots[i].amount = 1
            updated.emit()
            return
            
func removeSlot(inventorySlot: InventorySlot):
    var index = slots.find(inventorySlot)
    if index < 0:
        return
    slots[index] = InventorySlot.new()
    
func insertSlot(index: int, inventorySlot: InventorySlot):
    slots[index] = inventorySlot
