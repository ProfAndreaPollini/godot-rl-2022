extends Node


var capacity := 8
var coins := {}


func has_free_slot() -> bool:
	return get_child_count() < capacity

func add_item(item):
	add_child(item)
	EventBus.emit_signal("inventory_modified",self)
	
func total_coins():
	var total:=0.0
	for coin in coins:
		var quantity = coins[coin]
		total += quantity * coin["value"]
	return total
	
func add_coin(c):
	
	var coin = {
		"name": c.get_property("name"),
		"value": c.get_property("value")
		
	}
	if coins.has(coin):
		coins[coin] +=1
	else:
		coins[coin] =1
		
	EventBus.emit_signal("coins_modified")
