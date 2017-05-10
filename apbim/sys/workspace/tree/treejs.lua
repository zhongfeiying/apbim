
local function on_lbuttondown()
	print('on_lbuttondown')
end

local function on_rbuttondown()	
	print('on_rbuttondown')
end

Cmds = {}
Cmds:on_rbuttondown = on_rbuttondown
Cmds:on_lbuttondown = on_lbuttondown

return Cmds