gid_file = 
{
	owner = 'xxx';--默认为创建用户，不可转让，
	edit = nil/'xxx';--编辑用户，有权限提交版本，默认nil（owner自己），owner可收回edit权限。
	versions = {
			[1] = {
				hid = 'sdlfjaslfd';
				name = 'Cur name';
				time = 12345678;
				edit = 'xxx';
				message = '';
				associate={"gid","gid"};
			};
			...
	};	
};



