_ENV = module(...,ap.adv)


function send_change() 
	local code_view = get_code_view();	
	local code_sel_objs = get_code_sel_objs();	
	local code_files = get_code_files();	
	local code_project = get_code_project();	
	
	lcoal code = code_view .. code_sel_objs .. code_files .. code_project;	


	send_msg(code,send_to);
end	










