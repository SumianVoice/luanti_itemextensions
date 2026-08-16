
local core_get_node_drops = core.get_node_drops
rawset(core, "get_node_drops", function(node, toolname, tool, digger, pos)
	local drops = {}
	local normal_behavior = true
	local ndef = core.registered_nodes[node.name]
	if ndef and (ndef._get_node_drops) then
		normal_behavior = false
		local added = ndef._get_node_drops(node, toolname, tool, digger, pos, drops) or {}
		for i, v in ipairs(added) do table.insert(drops, v) end
	end
	local tdef = toolname and core.registered_items[toolname]
	if tdef and (tdef._get_tool_node_drops) then
		normal_behavior = false
		local added = tdef._get_tool_node_drops(node, toolname, tool, digger, pos, drops) or {}
		for i, v in ipairs(added) do table.insert(drops, v) end
	end
	if normal_behavior then
		return core_get_node_drops(node, toolname, tool, digger, pos)
	else
		return drops
	end
end)
