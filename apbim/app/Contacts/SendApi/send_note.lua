_ENV = module(...,ap.adv)



function send_sel_notes()
	local gids = get_cur_notes();
	local txt = get_note();
	local code = get_code_sel_notes(gids,txt);	
	code = get_code_project(code,txt);	
	--�ж��Ƿ���Ҫ�������Ϣ
	if(is_save_msg())then
		code = get_code_save_msg(code);
		--��ʱ�����Ƿ���Ҫ�ϴ�
		upload_objs(gids);
	end
	--�ж��Ƿ���Ҫ���Ѹ���Ϣ
	if(is_remind_msg())then
		code = get_code_remind_msg(code);
	end
	send_msg(code,send_to);
end