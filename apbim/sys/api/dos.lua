_ENV = module(...,ap.adv)

function start(str)
	os.execute('start " " "'..str..'"\n');
end

function del(str)
	os.execute('del "'..str..'" /q\n');
end

function md(str)
	if string.sub(str,-1)=='/' or string.sub(str,-1)=='\\' then str = string.sub(str,1,-2) end
	-- os.execute('@echo off\n');
	os.execute('md "'..str..'" \n');
	-- os.execute('@echo off\n md "'..str..'" \n');
end

function rd(str)
	os.execute("rd \""..str.."\" /s /q\n");
end

function copy(src,dst)
	os.execute('copy "'..src..'" "'..dst..'" \n');
end


