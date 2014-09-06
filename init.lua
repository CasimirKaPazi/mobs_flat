-- Dungeon Master
mobapi:register_mob("mobs_flat:dungeon_master", {
	type = "monster",
	hp_max = 20,
	stepheight = 1.1,
	collisionbox = {-0.7, -1, -0.7, 0.7, 1, 0.7},
	visual = "upright_sprite",
	textures = {"mobs_flat_dm_front.png", "mobs_flat_dm_back.png"},
	visual_size = {x=2, y=2},
	view_range = 15,
	walk_velocity = 1,
	run_velocity = 3,
	damage = 4,
	drops = {},
	armor = 60,
	drawtype = "front",
	water_damage = 0,
	lava_damage = 1,
	light_damage = 0,
	on_rightclick = nil,
	attack_type = "shoot",
	arrow = "mobs_flat:fireball",
	shoot_interval = 2.5,
})
mobapi:register_spawn("mobs_flat:dungeon_master", {"default:cobble, default:mossycobble"}, 2, -1, 140, 1, 32)

mobapi:register_arrow("mobs_flat:fireball", {
	visual = "sprite",
	visual_size = {x=1, y=1},
	textures = {"mobs_flat_fireball.png"},
	velocity = 5,
	hit_player = function(self, player)
		local s = self.object:getpos()
		local p = player:getpos()
		local vec = {x=s.x-p.x, y=s.y-p.y, z=s.z-p.z}
		player:punch(self.object, 1.0,  {
			full_punch_interval=1.0,
			damage_groups = {fleshy=4},
		}, vec)
		local pos = self.object:getpos()
		for dx=-1,1 do
		for dy=-1,1 do
		for dz=-1,1 do
			local p = {x=pos.x+dx, y=pos.y+dy, z=pos.z+dz}
			local n = minetest.env:get_node(pos).name
			if minetest.registered_nodes[n].groups.flammable or math.random(1, 100) <= 30 then
				minetest.env:set_node(p, {name="fire:basic_flame"})
			else
				minetest.env:remove_node(p)
			end
		end
		end
		end
	end,
	hit_node = function(self, pos, node)
		for dx=-1,1 do
		for dy=-2,1 do
		for dz=-1,1 do
			local p = {x=pos.x+dx, y=pos.y+dy, z=pos.z+dz}
			local n = minetest.get_node(pos).name
			if minetest.registered_nodes[n].groups.flammable or math.random(1, 100) <= 30 then
				minetest.set_node(p, {name="fire:basic_flame"})
			else
				minetest.remove_node(p)
			end
			nodeupdate(p)
		end
		end
		end
	end
})

-- Oerkki
mobapi:register_mob("mobs_flat:oerkki", {
	type = "monster",
	hp_max = 5,
	collisionbox = {-0.4, -1, -0.4, 0.4, 0.8, 0.4},
	stepheight = 1.1,
	visual = "upright_sprite",
	textures = {"mobs_flat_oerkki_front.png", "mobs_flat_oerkki_back.png"},
	visual_size = {x=2, y=2},
	view_range = 15,
	walk_velocity = 1,
	run_velocity = 3,
	damage = 1,
	drops = {},
	armor = 100,
	drawtype = "front",
	water_damage = 1,
	lava_damage = 1,
	light_damage = 0,
	attack_type = "dogfight",
})
mobapi:register_spawn("mobs_flat:oerkki", {"default:stone"}, 5, -1, 7000, 5, 32)

-- OMSK Bird
mobapi:register_mob("mobs_flat:omsk", {
	type = "monster",
	hp_max = 8,
	collisionbox = {-0.4, -1, -0.4, 0.4, 0.8, 0.4},
	stepheight = 1.1,
	visual = "upright_sprite",
	textures = {"mobs_flat_omsk_front.png", "mobs_flat_omsk_back.png"},
	visual_size = {x=2, y=2},
	view_range = 10,
	walk_velocity = 1,
	run_velocity = 2,
	damage = 4,
	drops = {},
	armor = 200,
	drawtype = "front",
	water_damage = 1,
	lava_damage = 1,
	light_damage = 0,
	attack_type = "dogfight",
})
mobapi:register_spawn("mobs_flat:omsk", {"default:stone", "default:cobble", "default:mossycobble"}, 20, -1, 14000, 1, -64)

-- Rat
mobapi:register_mob("mobs_flat:rat", {
	type = "animal",
	hp_max = 1,
	stepheight = 1.1,
	collisionbox = {-0.4, -0.5, -0.4, 0.4, 0.2, 0.4},
	visual = "upright_sprite",
	textures = {"mobs_flat_rat.png", "mobs_flat_rat.png"},
	walk_velocity = 1,
	armor = 200,
	drops = {},
	drawtype = "side",
	water_damage = 1,
	lava_damage = 1,
	light_damage = 0,
	on_rightclick = function(self, clicker)
		if clicker:is_player() and clicker:get_inventory() then
			clicker:get_inventory():add_item("main", "mobs_flat:rat_caught")
			self.object:remove()
		end
	end,
})
mobapi:register_spawn("mobs_flat:rat", {"default:dirt_with_grass", "default:stone"}, 20, -1, 14000, 1, 31000)

minetest.register_craftitem("mobs_flat:rat_caught" ,{
	description = "Rat",
	inventory_image = "mobs_flat_rat_caught.png",
	wield_image = "mobs_flat_rat_caught.png^[transformR90",
	on_place = function(itemstack, placer, pointed_thing)
		if pointed_thing.type ~= "node" then
			return
		end
		pointed_thing.under.y = pointed_thing.under.y + 1
		minetest.env:add_entity(pointed_thing.under, "mobs_flat:rat")
		itemstack:take_item()
		return itemstack
	end,
})

minetest.register_craftitem("mobs_flat:rat_cooked", {
	description = "Cooked Rat",
	inventory_image = "mobs_flat_rat_cooked.png",
	on_use = minetest.item_eat(4),
	cooktime = 5,
})

minetest.register_craft({
	type = "cooking",
	output = "mobs_flat:rat_cooked",
	recipe = "mobs_flat:rat_caught",
})

minetest.register_alias("default:rat", "mobs_flat:rat_caught")
minetest.register_alias("default:cooked_rat", "mobs_flat:rat_cooked")
