_ENV = module(...,ap.adv)


function send_print_screen()
	local gid = get_print_screen_file();
	upload(gid);
	--在文件上传完成后
	local txt = get_note();
	lcoal code = get_code_print_screen(gid,txt);	
	send_msg(code,send_to);
	
	
end










