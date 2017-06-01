----[===[
return {
		language_package = {
			User = {
				English = 'User';
				Chinese = '用户';
			};
			Login = {
				English = 'Login';
				Chinese = '登陆';
			};
			Logout = {
				English = 'Logout';
				Chinese = '登出';
			};
			['Change Password'] = {
				English = 'Change Password';
				Chinese = '修改密码';
			};
			['Project'] = {
				English = 'Project';
				Chinese = '项目';
			};
			['New'] = {
				English = 'New';
				Chinese = '新建';
			};
			['Open'] = {
				English = 'Open';
				Chinese = '打开';
			};
			['Save'] = {
				English = 'Save';
				Chinese = '保存';
			};
			['Statistics'] = {
				English = 'Statistics';
				Chinese = '统计';
			};
			['Model'] = {
				English = 'Model';
				Chinese = '模型';
			};
			['Properties'] = {
				English = 'Properties';
				Chinese = '属性';
			};
			['Edit'] = {
				English = 'Edit';
				Chinese = '编辑';
			};
			['Copy'] = {
				English = 'Copy';
				Chinese = '拷贝';
			};
			['Move'] = {
				English = 'Move';
				Chinese = '移动';
			};
			['Delete'] = {
				English = 'Delete';
				Chinese = '删除';
			};
			['View'] = {
				English = 'View';
				Chinese = '视图';
			};
			['Centered Show'] = {
				English = 'Centered Show';
				Chinese = '中心显示';
			};
			['File'] = {
				English = 'File';
				Chinese = '文件';
			};
			['Cooperate'] = {
				English = 'Cooperate';
				Chinese = '协同';
			};
			['Family'] = {
				English = 'Family';
				Chinese = '族';
			};
			['System'] = {
				English = 'System';
				Chinese = '系统';
			};
			['Company/Personal'] = {
				English = 'Company/Personal';
				Chinese = '公司/个人';
			};
			['Window'] = {
				English = 'Window';
				Chinese = '窗口';
			};
			['Help'] = {
				English = 'Help';
				Chinese = '帮助';
			};
		};
   		{
		name = 'User';
		subs = {
			{
				name = 'Login';
				keyword = 'ApBIM.User.Login';
			};
			{
				name = 'Logout';
				keyword = 'ApBIM.User.Logout';
			};
			{
				name = 'Change Password';
				keyword = 'ApBIM.User.Change Password';
			};
		};
	};
	{
		name = 'Project';
		subs = {
			{
				name = "New";
		--		keyword ='AP.Project.New';
			};
			{
				name = "Open";
		--		keyword ='AP.Project.Open';
			};
			{
				name = "Save";
		--		keyword ='AP.Project.Save';
			};
			{};
			{
				name = "Statistics";
		--		keyword ='AP.Project.Save';
			};
		};
	};
	{
		name = 'Model';
		subs = {
			{
				name = 'Edit';
				subs = {
					{
						name = 'Properties';
					};
					{};
					{
						name = 'Copy';
					};
					{
						name = 'Move';
					};
					{
						name = 'Delete';
					};
				};
			};
			{
				name = 'View';
				subs = {
					{
						name = 'New';
					};
					{
						name = 'Centered Show';
					};
				};
			};			
		};
	};
	{
		name = 'File';
		subs = {};
	};
	{
		name = 'Cooperate';
		subs = {};
	};
	{
		name = 'Family';
		subs = {
			{
				name = 'System';
			};
			{
				name = 'Company/Personal';
			};
		};
	};
	{
		name ='Window';
		subs = {};
	};
	{
		name ='Help';
		subs = {};
	};
}
--]===]
--[==[
return  {
   	{
  	 	name = "File";
  	 	subs = {
  	 	 	{
  	 	 	 	name = "BIM";
				subs = {
					{
						name = "New";
						keyword ='AP.BIM.New';
					};
				};
  	 	 	};
  	 	 	{
  	 	 	 	name = "Project";
				subs = {
					{
						name = "New";
						keyword ='AP.Project.New';
					};
					{
						name = "Open";
						keyword ='AP.Project.Open';
					};
					{
						name = "Save";
						keyword ='AP.Project.Save';
					};
				};
  	 	 	};
  	 	 	{
  	 	 	 	name = "Import";
				subs = {
					{
						name = "Lua";
						keyword ='AP.Work.Import.Lua';
					};
					{
					};
					{
						name = "Tekla";
						keyword ='AP.Project.Import.Tekla';
					};
					{
						name = "Tekla From File";
						keyword ='AP.Project.Import.Tekla From File';
					};
					{
					};
					{
						name = "Revit";
						keyword ='AP.Project.Import.Revit';
					};
					{
						name = "SketchUp";
						keyword ='AP.Project.Import.SketchUp';
					};
					
				};
  	 	 	};
  	 	 	{
  	 	 	 	name = "Export";
				subs = {
					{
						name = "Lua";
						keyword ='AP.Work.Export.Lua';
					};
				};
  	 	 	};
  	 	};
  	};
 	{
  	 	name = "View";
  	 	subs = {
  	 	 	{
  	 	 	 	name = "New";
  	 	 	 	keyword ='AP.View.New';
  	 	 	};
  	 	 	{
  	 	 	 	name = "Show";
  	 	 	 	keyword ='AP.View.Show';
  	 	 	};
  	 	 	{
  	 	 	 	name = "Hide";
  	 	 	 	keyword ='AP.View.Hide';
  	 	 	};
  	 	 	{
  	 	 	 	name = "Fit";
  	 	 	 	keyword ='AP.View.Fit';
  	 	 	};
			{};
			{
				name = "Default";
				keyword ='AP.View.Mode.Default';
			};
			{
				name = "3D";
				keyword ='AP.View.Mode.3D';
			};
			{
				name = "Top";
				keyword ='AP.View.Mode.Top';
			};
			{
				name = "Front";
				keyword ='AP.View.Mode.Front';
			};
			{
				name = "Back";
				keyword ='AP.View.Mode.Back';
			};
			{
				name = "Left";
				keyword ='AP.View.Mode.Left';
			};
			{
				name = "Right";
				keyword ='AP.View.Mode.Right';
			};
			{
				name = "Bottom";
				keyword ='AP.View.Mode.Bottom';
			};
  	 	};
  	};
 	{
  	 	name = "Show";
  	 	subs = {
  	 	 	{
  	 	 	 	name = "Property";
  	 	 	 	keyword ='AP.Show.Property';
  	 	 	};
			{};
  	 	 	{
  	 	 	 	name = "Diagram";
  	 	 	 	keyword ='AP.Show.Diagram';
  	 	 	};
  	 	 	{
  	 	 	 	name = "Wireframe";
  	 	 	 	keyword ='AP.Show.Wireframe';
  	 	 	};
  	 	 	{
  	 	 	 	name = "Rendering";
  	 	 	 	keyword ='AP.Show.Rendering';
  	 	 	};
  	 	};
  	};
 	{
  	 	name = "Select";
  	 	subs = {
  	 	 	{
  	 	 	 	name = "Cursor";
  	 	 	 	keyword ='AP.Select.Cursor';
  	 	 	};
			{};
  	 	 	{
  	 	 	 	name = "All";
  	 	 	 	keyword ='AP.Select.All';
  	 	 	};
  	 	 	{
  	 	 	 	name = "Cancel";
  	 	 	 	keyword ='AP.Select.Cancel';
  	 	 	};
  	 	 	{
  	 	 	 	name = "Reverse";
  	 	 	 	keyword ='AP.Select.Reverse';
  	 	 	};
  	 	};
  	};
 	{
  	 	name = "Edit";
  	 	subs = {
  	 	 	{
  	 	 	 	name = "Property";
  	 	 	 	keyword ='AP.View.Property';
  	 	 	};
			{};
  	 	 	{
  	 	 	 	name = "Copy";
  	 	 	 	keyword ='AP.View.Copy';
  	 	 	};
  	 	 	{
  	 	 	 	name = "Move";
  	 	 	 	keyword ='AP.View.Move';
  	 	 	};
  	 	 	{
  	 	 	 	name = "Del";
  	 	 	 	keyword ='AP.View.Del';
  	 	 	};
  	 	};
  	};
 	{
  	 	name = "Snap";
  	 	subs = {
  	 	 	{
  	 	 	 	name = "Point";
  	 	 	 	keyword ='AP.Snap.Point';
  	 	 	};
  	 	};
  	};
 	{
  	 	name = "Graphics";
  	 	subs = {
  	 	 	{
  	 	 	 	name = "Draw";
				subs = {
					{
						name = "Line";
						keyword ='AP.Graphics.Darw.Line';
					};
				};
  	 	 	};
  	 	};
  	};
 	{
  	 	name = "Steel";
  	 	subs = {
  	 	 	{
  	 	 	 	name = "Draw";
				subs = {
					{
						name = "Beam";
						keyword ='AP.Steel.Darw.Beam';
					};
				};
  	 	 	};
  	 	 	{
  	 	 	 	name = "Model";
				subs = {
					{
						name = "CGB";
						keyword ='AP.Steel.Model.CGB';
					};
				};
  	 	 	};
  	 	};
  	};
    {
  	 	name = "Model";
  	 	subs = {
  	 	 	{
  	 	 	 	name = "Show";
				subs = {
					{
						name = "All";
						keyword ='AP.Model.Show.All';
					};
					{};
					{
						name = "Diagram";
						keyword ='AP.Model.Show.Diagram';
					};
					{
						name = "Wireframe";
						keyword ='AP.Model.Show.Wireframe';
					};
					{
						name = "Rendering";
						keyword ='AP.Model.Show.Rendering';
					};
				};
  	 	 	};
			{
				name = "Report";
				subs = {
					{
						name = "Selection";
						keyword ='AP.Report.Selection';
					};
					{
						name = "View";
						keyword ='AP.Report.View';
					};
					{
						name = "All";
						keyword ='AP.Report.All';
					};
				};
			};
  	 	 	{
  	 	 	 	name = "Database";
				subs = {
					{
						name = "Show";
						keyword ='AP.Work.Database.Show';
					};
					{
						name = "Find";
						keyword ='AP.Work.Database.Find';
					};
				};
  	 	 	};
  	 	};
  	};
 	{
  	 	name = "Tools";
  	 	subs = {
  	 	 	{
  	 	 	 	name = "Restart";
  	 	 	 	keyword ='AP.Tools.Restart';
  	 	 	};
  	 	};
  	};
 	{
  	 	name = "Window";
  	 	subs = {
  	 	 	{
  	 	 	 	name = "Close";
  	 	 	 	keyword ='AP.Help.About';
  	 	 	};
  	 	 	{
  	 	 	 	name = "Close All";
  	 	 	 	keyword ='AP.Help.About';
  	 	 	};
			{};
  	 	};
  	};
 	{
  	 	name = "Help";
  	 	subs = {
  	 	 	{
  	 	 	 	name = "About";
  	 	 	 	keyword ='AP.Help.About';
  	 	 	};
  	 	};
  	};
};
--]==]
