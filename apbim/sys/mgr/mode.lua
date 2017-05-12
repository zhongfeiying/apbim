_ENV = module(...,ap.adv)


cur_ = {};
lighting_ = false;
gray_ = false;

function set_line()
	cur_.line = not cur_.line;
end

function set_frame()
	cur_.frame = not cur_.frame;
end

function set_render()
	cur_.render = not cur_.render;
end

function set_light()
	lighting_ = not lighting_;
	trace_out("set_lighting("..tostring(lighting_)..")\n");
	set_lighting(lighting_)
end

function set_gray()
	gray_ = not gray_;
	-- set_lighting(lighting_)
end

function get()
	return cur_;
end

function get_lighting()
	return lighting_;
end

function get_gray()
	return gray_;
end