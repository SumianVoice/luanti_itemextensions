function itemextensions.get_eyepos(player)
	local eyepos = vector.add(player:get_pos(), vector.multiply(player:get_eye_offset(), 0.1))
	eyepos.y = eyepos.y + player:get_properties().eye_height
	return eyepos
end

-- checks if can rightclick node/entity etc, returns itemstack if it did find something, else nil
function itemextensions.try_rightclick(itemstack, user, pointed_thing, dry)
	if not pointed_thing then return end
	if not core.is_player(user) then return nil end
	local ctrl = user:get_player_control()
	if ctrl and ctrl.sneak then return nil end
	if pointed_thing.ref then
		-- There is no way to know whether an entity's on_rightclick was used for something
		-- this means you either shoot someone you're trying to talk to, or can't shoot something
		-- that is attacking you.
		local ent = (user ~= pointed_thing.ref) and pointed_thing.ref:get_luaentity()
		if ent and ent.on_rightclick then
			return itemstack
		end
	elseif pointed_thing.type == "node" then
		local def = core.registered_nodes[core.get_node(pointed_thing.under).name]
		if def.on_rightclick then
			if not dry then
				local node = core.get_node(pointed_thing.under)
				itemstack = def.on_rightclick(pointed_thing.under, node, user, ItemStack(itemstack), pointed_thing) or itemstack
			end
			return itemstack
		end
		return
	end
	return nil
end
