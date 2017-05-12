
_ENV = module(...,ap.adv)
local db = {
	[1] = {
		Kind = 'BRANCH'; --类型文件夹还是文件
		Attr = {--节点附着的数据
			['hello'] = 'world';
		};
		Color = '200 200 200';--节点显示的颜色
		Title = 'Word';--节点显示的标题
		Datas = {--如果是当前节点是文件夹，那么它的子节点数据存放在这个key对应的表中
			[1] = {
				Kind = 'BRANCH';
				Attr = {
					['NBA'] = true;
				};
				Color = '255 1 1';
				Title = 'Hello';
			};
			[2] = {
				Kind = 'LEAF';
				Attr = {
					['CBN'] = true;
				};
				Color = '1 1 1';
				Title = 'LUA';
			};
		};
	};
}

function get_test_datas()
	return db
end