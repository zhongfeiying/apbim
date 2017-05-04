_ENV = module(...,ap.adv)

-- arg={scene=;file=;}
function save_bmp(arg)
	local exname = '.bmp';
	local sc = arg.scene;
	local file = string.sub(arg.file,-4,-1)==exname and arg.file or arg.file..exname;
	save_image(sc,file);
	return file;
end

-- arg={scene=;file=;}
function save_jpg(arg)
	save_image(arg.scene,arg.file..".bmp");
	-- local cmd = "start convert.exe \" \" \""..arg.file..".bmp\" \""..arg.file..".jpg\"\n";
	local cmd = "convert.exe \" \" \""..arg.file..".bmp\" \""..arg.file..".jpg\"\n";
	trace_out(cmd);
	os.execute(cmd);
	return arg.file..".jpg";
end

