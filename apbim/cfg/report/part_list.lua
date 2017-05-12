--[[
return {
	Remark = "Section,Mat,Lenth,Weight and Price.";
	{--Sheet1
		Row = 3;
		Columns = {
			[1] = function(arg)
				return tonumber(arg.i or "");
			end;
			[2] = function(arg)
				return tostring(arg.v.Section or "");
			end;
			[3] = function(arg)
				return tostring(arg.v.Mat or "");
			end;
			[4] = function(arg)
				return tonumber(arg.v.Count or 1);
			end;
			[5] = function(arg)
				return tonumber(arg.v:get_length() or 0);
			end;
			[6] = function(arg)
				return tonumber(arg.v:get_length() or 0) * tonumber(arg.v.Count or 1);
			end;
			[7] = function(arg)
				return tonumber(arg.v.Weight or 0);
			end;
			[8] = function(arg)
				return tonumber(arg.v.Weight or 0) * tonumber(arg.v.Count or 1);
			end;
			[9] = function(arg)
				return tonumber(arg.v.Price or 0);
			end;
			[10] = function(arg)
				return tonumber(arg.v.Price or 0) * tonumber(arg.v.Count or 1);
			end;
		};
		Filter = function(arg)
			if type(arg.v.Section)=='string' and type(arg.v.get_length)=='function' then
				return true;
			else
				return false;
			end
		end;
		Unite = function(arg)
			if 	tostring(arg.v1.Mat or "")==tostring(arg.v2.Mat or "") and
				tostring(arg.v1.Section or "")==tostring(arg.v2.Section or "") and
				math.abs(tonumber(arg.v1:get_length() or 0)-tonumber(arg.v2:get_length() or 0))<0.01 then
				return true
			else
				return false
			end
		end;
		Sort = function(arg)
			if tostring(arg.v1.Section or "")<tostring(arg.v2.Section or "") then
				return true
			elseif tostring(arg.v1.Section or "")>tostring(arg.v2.Section or "") then
				return false
			elseif tostring(arg.v1.Mat or "")<tostring(arg.v2.Mat or "") then
				return true
			elseif tostring(arg.v1.Mat or "")>tostring(arg.v2.Mat or "") then
				return false
			elseif tonumber(arg.v1:get_length() or 0)<tonumber(arg.v2:get_length() or 0) then
				return true
			else 
				return false
			end
		end;
	};
};
--]]

return function(dat)
	local book = {{from=1}};
	local sheet = book[1];
	local row,col = 3,1;
	for k,v in pairs(dat) do
		sheet[row] = {};
		local cols = sheet[row];
		cols[2] = v.Section or "";
		cols[3] = v.Mat or "";
		cols[4] = v.Count or 1;
		cols[5] = type(v.get_length)=='function' and v:get_length() or 0;
		row = row + 1;
	end
	return book;
end
