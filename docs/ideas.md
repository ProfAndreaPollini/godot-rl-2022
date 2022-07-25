mariodose: ok ho visto gli asset per quanto siano tutti nello stesso genere ma molto differenti opterei per un ambientaione di un mondo frastagliato in 3 macro aree (area dei sotterranei dei reietti) area del bosco e della natura dove le arti dei druidi hanno preso il sopravento e la parte degli uomini , ora corrotti, che hanno eretto un muro di cinta e vorrebbe allargarsi , dove una istituzione simil chiesa sta facendo di tutto per plagiare le persone e e convincerle a togliere gli equilibri mariodose: ogni arma ha casualmente un valore di attacco pari al livello del personaggio + un numero randomico che va da 1 a 12 moltiplicato per il valore di rarità  


mariodose: allora tornando al gioco l'inventario potrebbe esse studiato cosi: avere un equip per zona del corpo tipo " testa , busto , gambali , scarpa e mani e back , nel back puoi mettere zaino e ogni zaino ha un inventario con diversi slot

MinotauroDiKyoto: 3 tipi diversi di borse/inventario che si possono comprare con i punti guadagnati

mariodose: direi che potremmo mettere nel HUD 3 slot sempre sempre presenti di cui 2 con tasti rapidi (1 e 2) dove mettere pozioni o robe del genere e nel terzo mettere lo zaino che ti da l'inventario full completo

mariodose: ti apre questo inventario dove ci sono i quadratini in base alla capienza e rarià dello zaino e a destra slot testa busto arma gambe scarpe

skaman512: le spade possono avere anche 2 valori monetari. Uno di vendita e uno di acquisto. Poi possono avere un valore che è il livello minimo che devi avere per usarla. Un valore che sono i danni. E poi non so

paulus1969: se abbiamo le monete dobbiamo avere un negozio per spenderle

mariodose: io metterei solo un valore di acquisto , metterei che il venditore , quando acquista toglie il 30% del valore

AngelOfDeath_V: potresti fare la moneta per comprare con una percentuale scelta da te ed ogni 2 giorni a uno sconto di una percentuale randomica

mariodose: item deve avere queste proprietà secondo me (aggiugete o cambiate se trovate migliori) " rarità , è usabile? , attack speed , attack damage , def , integrità , prezzo acquisto "

paulus1969: poi al PG diamo una sola moneta il cui valore aumenta a mano a mano che raccoglie monete e diminuisce quando acquista cose, così è la monetona stessa che funge da borsellino

paulus1969: adesso farei così: la moneta scompare, il campo value del personaggio aumenta del valore contenuto nel campo value della moneta ed accanto scriviamo per un secondo "+100"
AngelOfDeath_V: potresti fare una base della vita da del mana con due pozioni che le compri o le trovi in mappa


extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var is_firing := false
var old_global_position := Vector2.ZERO
var COOLDOWN_TIME := 0.1
var fire_time := 0.0
var direction = Vector2.ZERO

onready var owner_entity = null #get_parent().get_parent()


func on_mouse_moved(pos: Vector2,dir: Vector2):
	direction = dir
	var weapon_position =  pos + 10*dir
	
	global_position  = pos
	look_at(pos + 100*dir)
	rotate(deg2rad(90))
	

func _process(delta):
	if not owner_entity: return
	
	if Input.is_action_just_pressed("ui_accept") and not is_firing:
		fire_time = delta
		is_firing = true
		old_global_position = global_position
		global_position += 10*owner_entity.direction
	elif Input.is_action_pressed("ui_accept") and is_firing:
		fire_time += delta 
	elif Input.is_action_just_released("ui_accept") and fire_time > COOLDOWN_TIME:
		is_firing = false
		global_position = old_global_position
	



func _on_Sword_body_entered(entity):
	if entity.can_equip(self):
		get_parent().remove_child(self)
		entity.add_weapon(self)
