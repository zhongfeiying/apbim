_ENV = module(...,ap.adv)

function get_shirr_line(pt1,pt2)
	return {
		index = require"sys.mgr.drag".get_shirr_index();
		surfaces = {
			{
				textured = 0;
				points = {
					{1,1,1,0,0,pt1.x,pt1.y,pt1.z};
					{0.8,0.8,0.8,0,0,pt2.x,pt2.y,pt2.z};
				};
				lines = {
					{1,2};
				};
			};
		};
	};
end

function get_shirr_index()
	return require"sys.mgr.drag".get_shirr_index();
end

function is_running()
	return require"sys.mgr.drag".is_running();
end

function update(sc)
	require"sys.mgr.drag".update(sc);
end

function start(sc)
	require"sys.mgr.drag".start(sc);
end

function stop(sc)
	require"sys.mgr.drag".stop(sc);
end

-- arg={scene=,object}
function draw(arg)
	require"sys.mgr.drag".draw(arg.scene,arg.object);
end

-- arg={scene=,pt1=,pt2=}
function draw_shirr_line(arg)
	local obj = get_shirr_line(arg.pt1,arg.pt2);
	require"sys.mgr.drag".draw(arg.scene,obj);
end
