_ENV = module(...,ap.adv)

function frm_on_command(id)
	if(require"sys.interface.id".frm_commands()[id])then
		require"sys.interface.id".frm_commands()[id]();
	else
		-- trace_out("frm_on_command(id): id = " .. id ..", there isn't the function\n");
	end
end

function on_command(id,scene)
	if(require"sys.interface.id".commands()[id])then
		require"sys.interface.id".commands()[id](scene);
	else
		-- trace_out("on_command(id,scene): id = " .. id ..", there isn't the function\n");
	end
end

function on_timer(scene,id)
	if(require"sys.interface.id".timers()[id])then
		require"sys.interface.id".timers()[id](scene);
	else
		trace_out("id = " .. id ..", there isn't the function\n");
	end
end
