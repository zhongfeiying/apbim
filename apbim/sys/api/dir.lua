_ENV = module(...,ap.adv)

local tbj_ = require"sys.api.dir.dir_tbj"
local js_ = require"sys.api.dir.dir_js"
local wyg_ = require"sys.api.dir.dir_wyg"
local lsy_ = require"sys.api.dir.dir_lsy"

function is_there_file(str)
	return tbj_.is_there_file(str);
end

function get_subfolder_list(str)
	return tbj_.get_subfolder_list(str);
end

function get_subfile_list(str,exname)
	return tbj_.get_subfile_list(str,exname);
end

function create(str)
	return wyg_.create(str)
end

function is_there(str)
	return wyg_.is_there (str)
end

function create_folder(str)
	return wyg_.create_folder(str)
end

function get_filename_list(str)
	local t = js_.get_file(str)
	return t
end

function get_main_path()
	return lsy_.get_main_path();
end
