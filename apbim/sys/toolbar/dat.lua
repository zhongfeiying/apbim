_ENV = module(...)

--[[
keywords_={
	[keyword]={
		name='Move',
		remark=,
		action=,
		view=,
		frame=,
		image=,
		disable=,
		checkbox=,
		shortcut=,
		hotkey=,
		},
	...
}
--]]

local keywords_ = {};

function init()
	keywords_ = {};
end

function get_all()
	return keywords_;
end

function add(t)
	if not t.keyword then return end
	keywords_[t.keyword] = t;
end

function get(keyword)
	return keywords_[keyword];
end

