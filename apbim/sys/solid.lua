_ENV = module(...,ap.adv)


Line = require"sys.api.solid".Line;
Frame = require"sys.api.solid".Frame;
Render = require"sys.api.solid".Render;

function x_position()
	return require"sys.api.solid".x_position(t);
end

--t={
--	index=;
--	mode=Line/Frame/Render;
--	solid={
--		color={r=1,g=0,b=0};
--		bottom={
-- 			base=
--			outer={},
--			inters={{},{}};
--		};
--		top={};
--		length=10000;
--	};
--	placement = {};
--};
function extrude(t)
	return require"sys.api.solid".extrude(t);
end

--t={
--	index=;
--	mode=Line/Frame/Render;
--	solid={
--		color={r=1,g=0,b=0};
--		bottom={
-- 			base=
--			outer={},
--			inters={{},{}};
--		};
--		top={};
--		angle=10000;
--	};
--};
function revolve(t)
	return require"sys.api.solid".revolve(t);
end



