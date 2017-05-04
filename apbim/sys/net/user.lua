

_ENV = module(...,ap.adv)

local login_cbf_ = nil
local reg_cbf_ = nil
local passwd_cbf_ = nil

function endof_login(gid)
	if type(login_cbf_)=='function' then login_cbf_(gid) end
	login_cbf_ = nil;
end

function endof_reg(result)
	if type(reg_cbf_)=='function' then reg_cbf_(result) end
	reg_cbf_ = nil;
end

function endof_passwd(result)
	if type(passwd_cbf_)=='function' then passwd_cbf_(result) end
	passwd_cbf_ = nil;
end

-- t={user=,password=,cbf=}
function login(t)
	login_cbf_ = t.cbf;
	require"sys.net.main".user_login(t.user,t.password);
end

-- t={user=,password=,gid=,mail=,phone=,cbf=}
function reg(t)
	reg_cbf_ = t.cbf;
	require"sys.net.main".user_reg(t.user,t.password,t.gid or string.upper(require'luaext'.guid()),t.mail,t.phone);
end

-- t={user=,password=,password_new,cbf=}
function passwd(t)
	passwd_cbf_ = t.cbf;
	require"sys.net.main".user_change_password(t.user,t.password,t.password_new);
end



