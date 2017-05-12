_ENV = module(...,ap.adv)
local function turn_unit(num) --Ó¢´ç×ªºÁÃ×
	return num
	--return num*25.4
end

local function to_decimal(molecule,denominator,int)--fenzi, fenfu
	local num = int + molecule/denominator
	return turn_unit(num)
end

local function turn_unit_str(str)
	local newstr = string.match(str,'(%a+)%d+') or ''
	if string.find(str,'/') then 
		local intnum = 0
		if string.find(str,'-') then intnum = string.match(str,'(%d+)-') end 
		local molecule = string.match(str,'(%d+)/')
		local denominator =string.match(str,'/(%d+)')
		newstr = newstr .. to_decimal(molecule,denominator,intnum)
	elseif string.find(str,'%.') then 
		local intnum = string.match(str,'(%d+)%.') 
		local smallnum = string.match(str,'%.(%d+)') 
		newstr = newstr .. turn_unit(str)
	else
		if string.find(str,'%d+') then 
			newstr = newstr .. turn_unit(string.match(str,'(%d+)'))
		end 
	end 
	return newstr
end

local function get_title(str)
	return string.match(str,'(%a+)')
end

local section_lib_ = {}
--C
section_lib_["C10X15.3"] = "C" .. turn_unit_str("10") .. "X" .. turn_unit_str('2-5/8') .. "X" .. turn_unit_str('1/4')
section_lib_["C12X20.7"] = "C" .. turn_unit_str("12") .. "X" .. turn_unit_str('3') .. "X" .. turn_unit_str('5/16')
section_lib_["C15X33.9"] = "C" .. turn_unit_str("15") .. "X" .. turn_unit_str('3-3/8') .. "X" .. turn_unit_str('3/8')
section_lib_["C8X11.5"] = "C" .. turn_unit_str("8") .. "X" .. turn_unit_str('2-1/4') .. "X" .. turn_unit_str('1/4')

section_lib_["HP10X42"] = "H" .. turn_unit_str("9-3/4") .. "X" .. turn_unit_str('10-1/8') .. "X" .. turn_unit_str('7/16') .. "X" .. turn_unit_str('7/16')

section_lib_["HSS4X4X1/2"] = "HSS" .. turn_unit_str("4") .. "X" .. turn_unit_str('4') .. "X" .. turn_unit_str('1/2')
section_lib_["HSS10X3-1/2X1/2"] = "HSS" .. turn_unit_str("10") .. "X" .. turn_unit_str('3-1/2') .. "X" .. turn_unit_str('1/2')
section_lib_["HSS1.660X0.140"] = "HSS" .. turn_unit_str("1.660") .. "X" .. turn_unit_str('0.140')


---M
section_lib_["M10X7.5"] = "H" .. turn_unit_str("10") .. "X" .. turn_unit_str('2-3/4') .. "X" .. turn_unit_str('1/8')  .. "X" .. turn_unit_str('3/16')  
section_lib_["M12.5X11.6"] = "H" .. turn_unit_str("12.5") .. "X" .. turn_unit_str('3-1/2') .. "X" .. turn_unit_str('1/8')  .. "X" .. turn_unit_str('3/16')  

---MC
section_lib_["MC10X22"] = "C" .. turn_unit_str("10") .. "X" .. turn_unit_str('3-3/8') .. "X" .. turn_unit_str('5/16')

---MT
section_lib_["MT2.5X9.45"] = "T" .. turn_unit_str("2-1/2") .. "X" .. turn_unit_str('5') .. "X" .. turn_unit_str('5/16') .. "X" .. turn_unit_str('7/16')

---Pipe
section_lib_["PIPE1-1/2STD"] = "P" .. turn_unit_str("1.9") .. "X" .. turn_unit_str('0.145')


---S
section_lib_["S10X25.4"] = "H" .. turn_unit_str("10") .. "X" .. turn_unit_str('4-5/8').. "X" .. turn_unit_str('5/16') .. "X" .. turn_unit_str('1/2')

---ST
section_lib_["ST1.5X2.85"] = "T" .. turn_unit_str("1-1/2") .. "X" .. turn_unit_str('2-3/8') .. "X" .. turn_unit_str('3/16') .. "X" .. turn_unit_str('1/4')


---W
section_lib_["W10X100"] = "H" .. turn_unit_str("11-1/8") .. "X" .. turn_unit_str('10-3/8').. "X" .. turn_unit_str('11/16') .. "X" .. turn_unit_str('1-1/8')
section_lib_["W14X43"] = "H" .. turn_unit_str("13-5/8") .. "X" .. turn_unit_str('8').. "X" .. turn_unit_str('5/16') .. "X" .. turn_unit_str('1/2')
section_lib_["W12X26"] = "H" .. turn_unit_str("12-1/4") .. "X" .. turn_unit_str('6-1/2').. "X" .. turn_unit_str('1/4') .. "X" .. turn_unit_str('3/8')
section_lib_["W18X55"] = "H" .. turn_unit_str("18-1/8") .. "X" .. turn_unit_str('7-1/2').. "X" .. turn_unit_str('3/8') .. "X" .. turn_unit_str('5/8')
section_lib_["W8X18"] = "H" .. turn_unit_str("8-1/8") .. "X" .. turn_unit_str('5-1/4').. "X" .. turn_unit_str('1/4') .. "X" .. turn_unit_str('5/16')
section_lib_["W12X35"] = "H" .. turn_unit_str("12-1/2") .. "X" .. turn_unit_str('6-1/2').. "X" .. turn_unit_str('5/16') .. "X" .. turn_unit_str('1/2')
section_lib_["W10X15"] = "H" .. turn_unit_str("10") .. "X" .. turn_unit_str('4').. "X" .. turn_unit_str('1/4') .. "X" .. turn_unit_str('1/4')
section_lib_["W18X50"] = "H" .. turn_unit_str("18") .. "X" .. turn_unit_str('7-1/2').. "X" .. turn_unit_str('3/8') .. "X" .. turn_unit_str('9/16')
section_lib_["W8X13"] = "H" .. turn_unit_str("8") .. "X" .. turn_unit_str('4').. "X" .. turn_unit_str('1/4') .. "X" .. turn_unit_str('1/4')
section_lib_["W12X30"] = "H" .. turn_unit_str("12-3/8") .. "X" .. turn_unit_str('6-1/2').. "X" .. turn_unit_str('1/4') .. "X" .. turn_unit_str('7/16')
section_lib_["W30X116"] = "H" .. turn_unit_str("30") .. "X" .. turn_unit_str('10-1/2').. "X" .. turn_unit_str('9/16') .. "X" .. turn_unit_str('7/8')
section_lib_["W18X35"] = "H" .. turn_unit_str("17-3/4") .. "X" .. turn_unit_str('6').. "X" .. turn_unit_str('5/16') .. "X" .. turn_unit_str('7/16')
section_lib_["W12X40"] = "H" .. turn_unit_str("12") .. "X" .. turn_unit_str('8').. "X" .. turn_unit_str('5/16') .. "X" .. turn_unit_str('1/2')
section_lib_["W12X53"] = "H" .. turn_unit_str("12") .. "X" .. turn_unit_str('10').. "X" .. turn_unit_str('3/8') .. "X" .. turn_unit_str('9/16')
section_lib_["W24X76"] = "H" .. turn_unit_str("23-7/8") .. "X" .. turn_unit_str('9').. "X" .. turn_unit_str('7/16') .. "X" .. turn_unit_str('11/16')
section_lib_["W16X40"] = "H" .. turn_unit_str("16") .. "X" .. turn_unit_str('7').. "X" .. turn_unit_str('5/16') .. "X" .. turn_unit_str('1/2')
section_lib_["W21X101"] = "H" .. turn_unit_str("21-3/8") .. "X" .. turn_unit_str('12-1/4').. "X" .. turn_unit_str('1/2') .. "X" .. turn_unit_str('13/16')
section_lib_["W27X94"] = "H" .. turn_unit_str("26-7/8") .. "X" .. turn_unit_str('10').. "X" .. turn_unit_str('1/2') .. "X" .. turn_unit_str('3/4')
section_lib_["W18X60"] = "H" .. turn_unit_str("18-1/4") .. "X" .. turn_unit_str('7-1/2').. "X" .. turn_unit_str('7/16') .. "X" .. turn_unit_str('11/16')
section_lib_["W12X65"] = "H" .. turn_unit_str("12-1/8") .. "X" .. turn_unit_str('12').. "X" .. turn_unit_str('3/8') .. "X" .. turn_unit_str('5/8')
section_lib_["W21X73"] = "H" .. turn_unit_str("21-1/4") .. "X" .. turn_unit_str('8-1/4').. "X" .. turn_unit_str('7/16') .. "X" .. turn_unit_str('3/4')
section_lib_["W24X176"] = "H" .. turn_unit_str("25-1/4") .. "X" .. turn_unit_str('12-7/8').. "X" .. turn_unit_str('3/4') .. "X" .. turn_unit_str('1-5/16')
section_lib_["W14X90"] = "H" .. turn_unit_str("14") .. "X" .. turn_unit_str('14-1/2').. "X" .. turn_unit_str('7/16') .. "X" .. turn_unit_str('11/16')


---WT
section_lib_["WT10.5X100.5"] = "T" .. turn_unit_str("11-1/2") .. "X" .. turn_unit_str('12-5/8') .. "X" .. turn_unit_str('15/16') .. "X" .. turn_unit_str('1-5/8')
section_lib_["WT5X15"] = "T" .. turn_unit_str("5-1/4") .. "X" .. turn_unit_str('5-3/4') .. "X" .. turn_unit_str('5/16') .. "X" .. turn_unit_str('1/2')



local function get_data(str)
	local t = {}
	for val in string.gmatch(str,'[^X+]+') do 
		table.insert(t,val)
	end 
	return t
end


section_lib_['HSS'] = function (str) 
	local num = 0
	local t = get_data(str)
	t[1] =  string.sub(t[1],4,-1)
	if #t == 2 then 
		return "HSS" .. turn_unit_str(t[1]) .. "X" .. turn_unit_str(t[2])  
	elseif #t == 3 then 
		return "HSS" .. turn_unit_str(t[1]) .. "X" .. turn_unit_str(t[2]) ..  "X" .. turn_unit_str(t[3])  
	end 
	
end 

section_lib_['L'] = function (str) 
	if string.sub(str,1,1) == '2' then 
		local t = get_data(str)
		t[1] = string.sub(t[1],3,-1)
		return 'TWOL'  .. turn_unit_str(t[1]) .. "X" .. turn_unit_str(t[2]) ..  "X" .. turn_unit_str(t[3]) 
	elseif  string.sub(str,1,1) == 'L' then 
		local t = get_data(str)
		t[1] = string.sub(t[1],2,-1)
		if #t == 3 then 
			return 'L' .. turn_unit_str(t[1]) .. "X" .. turn_unit_str(t[2]) ..  "X" .. turn_unit_str(t[3]) 
		end 
	end
end 

function get(str)
	if not str or str == '' then return str end 
	str = string.upper(str)
	local head = get_title(str)
	if section_lib_[str] then 
		return section_lib_[str]
	elseif head and type(section_lib_[head]) == 'function' then 
		return section_lib_[head](str)
	end 
	return str
end

