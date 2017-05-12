_ENV = module(...,ap.adv)

sels_ = {};--{id=ent}
cur_ = nil

function init()
	sels_ = {};
end

function get_all()
	return sels_;
end

function get(ent)
	return sels_[ent.mgrid];
end

function set(ent,light)
	if type(ent)~="table" then return end
	if not ent.mgrid then return end
	sels_[ent.mgrid] = light and ent or nil;
	cur_ = light and ent or nil;
end

function curs()
	return sels_;
end

function cur()
	if cur_ then return cur_ end
	for k,v in pairs(sels_) do
		return v;
	end
	return nil;
end

