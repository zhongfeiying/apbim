module(...,package.seeall)
--�жϱ��Ƿ�Ϊ�ձ�
function table_is_empty(t)
	return _G.next(t) == nil
end 