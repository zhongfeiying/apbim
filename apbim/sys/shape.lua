_ENV = module(...,ap.adv)


function color_scale(obj, coe)
	return require"sys.api.shape".color_scale(obj, coe);
end

function color_add(obj, cr)
	return require"sys.api.shape".color_add(obj, cr);
end

function color_to(obj, cr)
	return require"sys.api.shape".color_to(obj, cr);
end

function coord_l2g(obj, crd)
	return require"sys.api.shape".coord_l2g(obj, crd);
end

function coord_move(obj, off)
	return require"sys.api.shape".coord_move(obj, off);
end

-------------------------------

function coords_move(objs, off)
	return require"sys.api.shape".coords_move(objs, off);
end

-------------------------------

function merge(objs)
	return require"sys.api.shape".merge(objs);
end

