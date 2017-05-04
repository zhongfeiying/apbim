_ENV = module(...,ap.adv)



function get_subfolder_list(str)
	local subs = {};
	for ln in io.popen('dir "'..str..'" /d'):lines() do
		for sub in string.gmatch(ln,'%[[^]]+%]') do
			if sub ~="[.]" and sub~="[..]" then 
				-- table.insert(subs,string.sub(sub,2,-2));
				subs[string.sub(sub,2,-2)] = "folder";
			end
		end
	end
	return subs;
end

function get_subfile_list(str,exname)
	local n = string.len(exname);
	local subs = {};
	for ln in io.popen('dir "'..str..'" /d'):lines() do
		for sub in string.gmatch(ln,' [^]]+'..exname) do
			if sub ~="[.]" and sub~="[..]" then 
				-- table.insert(subs,string.sub(sub,2,-2));
				trace_out(string.sub(sub,1,-(n+1))..'\n')
				subs[string.sub(sub,1,-(n+1))] = "folder";
			end
		end
	end
	return subs;
end

function is_there_file(str)
	local f = io.open(str,"r");
	if not f then return end;
	f:close();
	return true;
end

