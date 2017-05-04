_ENV = module(...,ap.adv)

local timer_id_ = ID;
local command_id_ = ID;

local timers_ = {};--{[id]=function}
local commands_ = {};--{[id]=function}
local frm_commands_ = {};--{[id]=function}

function get_timer_id()
	timer_id_=timer_id_+1;
	return timer_id_;
end

function get_command_id()
	command_id_=command_id_+1;
	return command_id_;
end

function timers()
	return timers_;
end

function commands()
	return commands_;
end

function frm_commands()
	return frm_commands_;
end

-- t={id=,f=}
function set_timer(t)
	timers()[t.id] = t.f;
end

-- t={id=,f=}
function set_command(t)
	commands()[t.id] = t.f;
end

-- t={id=,f=}
function set_frm_command(t)
	frm_commands()[t.id] = t.f;
end
