_ENV = module(...,ap.adv)



function send_sel_notes()
	local gids = get_cur_notes();
	local txt = get_note();
	local code = get_code_sel_notes(gids,txt);	
	code = get_code_project(code,txt);	
	--判断是否需要保存该信息
	if(is_save_msg())then
		code = get_code_save_msg(code);
		--此时构件是否需要上传
		upload_objs(gids);
	end
	--判断是否需要提醒该信息
	if(is_remind_msg())then
		code = get_code_remind_msg(code);
	end
	send_msg(code,send_to);
end