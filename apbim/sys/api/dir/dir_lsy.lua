_ENV = module(...,ap.adv)

function get_main_path()
	local path = ""
	for file_path in io.popen('dir gcad.exe /b /s'):lines() do
		path = string.match(file_path, "(.+)\\[^\\]*%.%w+$");
		break;
	end
--	return string.sub(string.format("%q",path), 2, #string.format("%q",path)-1)
	return path.."\\"
end