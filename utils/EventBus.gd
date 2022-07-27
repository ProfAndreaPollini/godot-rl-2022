extends Node

# inventory signals

signal player_moved()
signal player_on_weapon(weapon)
signal player_exchange_weapon(new_weapon)

signal pocket_modified()
signal inventory_modified()
signal coins_modified()
signal weapon_modifed()

signal pick_coin(coin)

signal open_inventory()
signal close_inventory()
