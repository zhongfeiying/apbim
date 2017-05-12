module(...,package.seeall)
--判断表是否为空表
function table_is_empty(t)
	return _G.next(t) == nil
end 