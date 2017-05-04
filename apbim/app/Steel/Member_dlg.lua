_ENV = module(...,ap.adv)

--package.cpath = "?.dll;?53.dll;" .. package.cpath
-- require "iuplua"
-- require "iupluacontrols"
local btn_ok_;
local btn_modify_;
local btn_apply_;
local btn_cancel_;
local btn_select_;


local tab_attr_;
local lab_name_;
local txt_name_;
local lab_profile_;
local txt_profile_;
local lab_material_;
local txt_material_;

local lab_hor_;
local lab_ver_;
local lab_rotation_;

local txt_hor_val_;
local list_hor_;

local list_rotation_;
local txt_rotation_;

local list_ver_;
local txt_ver_val_;


local frame_lavels_;
local lab_top_;
local lab_bottom_;

local txt_bottom_;
local txt_top_;

local lab_beta_;
local txt_beta_;

local lab_pt_start_;
local lab_pt_end_;
local lab_pt_start_x_;
local lab_pt_start_y_;
local lab_pt_start_z_;

local txt_pt_start_x_;
local txt_pt_start_y_;
local txt_pt_start_z_;

local lab_pt_end_x_;
local lab_pt_end_y_;
local lab_pt_end_z_;

local txt_pt_end_x_;
local txt_pt_end_y_;
local txt_pt_end_z_;

local lab_mode_;
local list_mode_;
local list_mode_data_ = {'Rendering','Wireframe','Diagram'}

local lab_alignment_;
local txt_alignment_;
local lab_horizontal_;
local lab_vertical_;
local list_horizontal_;
local list_vertical_;

local list_alignment_h_data_ = {'Left','Center','Right',['Left'] = 0.5,['Center'] = 0,['Right'] = -0.5}
local list_alignment_v_data_ = {'Up','Center','Down',['Up'] = 0.5,['Center'] = 0,['Down'] = -0.5}



local lab_color_;
local lab_color_r_;
local lab_color_g_;
local lab_color_b_;

local txt_color_r_;
local txt_color_g_;
local txt_color_b_;

local lab_length_;
local txt_length_;

local lab_weight_;
local txt_weight_;



local list_hor_data_ = {'Middle','Right','Left'}
local list_rotation_data_ = {'Front','Top','Back','Below'}
local list_ver_data_ = {'Middle','Front','Behind'}
local list_ver_column_data_ = {'Middle','Down','Up'}

local exist_dlg_;


function pop()
	if exist_dlg_ then 
		exist_dlg_:hide()
	end
	local dlg_;
	
	local tog_ifo_ = {state = 'ON'}
	local column = false
	local cur = require 'sys.mgr'.cur()
	if not cur then iup.Message('Notice','Please select member !') return end 
	local curs = require 'sys.mgr'.curs() or {}
	
	
	local modify_cmd_ = {}
		modify_cmd_.Color = function (Cur)
		Cur.Color.r = txt_color_r_.value
		Cur.Color.g = txt_color_g_.value
		Cur.Color.b = txt_color_b_.value
		
		Cur.Color[1] = txt_color_r_.value
		Cur.Color[2] = txt_color_g_.value
		Cur.Color[3] = txt_color_b_.value
	end

	modify_cmd_.Spt = function (Cur,x,y,z)
		Cur.Points[1][1] = txt_pt_start_x_.value
		Cur.Points[1][2] = txt_pt_start_y_.value
		Cur.Points[1][3] = txt_pt_start_z_.value
		
		Cur.Points[1].x = txt_pt_start_x_.value
		Cur.Points[1].y = txt_pt_start_y_.value
		Cur.Points[1].z = txt_pt_start_z_.value
	end

	modify_cmd_.Ept = function (Cur)
		Cur.Points[2][1] = txt_pt_end_x_.value
		Cur.Points[2][2] = txt_pt_end_y_.value
		Cur.Points[2][3] = txt_pt_end_z_.value
		
		Cur.Points[2].x = txt_pt_end_x_.value
		Cur.Points[2].y = txt_pt_end_y_.value
		Cur.Points[2].z = txt_pt_end_z_.value
	end

	modify_cmd_.Alignment = function (Cur)
		local h,v = list_alignment_h_data_[list_horizontal_[list_horizontal_.value]] ,list_alignment_v_data_[ list_vertical_[list_vertical_.value] ]
		--local h,v = list_horizontal_[list_horizontal_.value],list_vertical_[list_vertical_.value]
		Cur.Alignment = {h,v}
		-- local h = h == 0.5 and 'Left' or h == 0 and 'Center' or 'Right'
		-- local v = v == 0.5 and 'Bottom' or h == 0 and 'Center' or 'Top'
		-- Cur.Info.Text.Alignment = h .. v
	end

	modify_cmd_.Beta = function (Cur)
		Cur.Beta = txt_beta_.value
	end

	modify_cmd_.Mode = function (Cur)
		Cur.Mode = list_mode_[list_mode_.value]
	end

	modify_cmd_.Type = function (Cur)
		Cur.name = txt_name_.value
	end

	modify_cmd_.Profile = function (Cur)
		Cur.Section = txt_profile_.value
	end

	modify_cmd_.Material = function (Cur)
		Cur.material = txt_material_.value
	end

	modify_cmd_.Length = function (Cur)
		Cur.Length = txt_length_.value
	end
	
	modify_cmd_.Weight = function (Cur)
		Cur.weight = txt_weight_.value
	end

	
	
	local function init_buttons()
		local btn_wid = '100x'
		local wid100 = '100x'
		btn_ok_ = iup.button{title = 'Ok',rastersize = btn_wid}
		btn_cancel_ = iup.button{title = 'Cancel',rastersize = btn_wid }
		btn_modify_ = iup.button{title = 'Modify',rastersize = btn_wid }
		btn_apply_ = iup.button{title = 'Apply',rastersize = btn_wid }
		btn_select_profile_= iup.button{title = 'Select ...',rastersize = wid100 }
		btn_select_profile_ = nil
		btn_select_material_= iup.button{title = 'Select ...',rastersize = wid100 }
		btn_select_material_ = nil
		tog_on_ = iup.toggle{value = 'ON',fontsize = '12'}
		tog_off_ = iup.toggle{fontsize = '12'}
		
		tog_frame_ = iup.frame{
			iup.hbox{
				tog_on_;
				iup.fill{rastersize = '5x'};
				iup.label{title = '/'};
				iup.fill{rastersize = '7x'};
				tog_off_;
			};
			margin = '0x0';
		}
		
	end

	local function get_list_hwnd(data)
		local list = iup.list(data)
		list.DROPDOWN = 'yes'
		list.rastersize = '100x'
		return list
	end
	
	local function get_tog(title)
		local tog = iup.toggle{}
		table.insert(tog_ifo_,{Title = title,Hwnd =tog})
		--print(title)
		tog.value = 'ON'
		return tog
	end
	
	local function init_controls()
		local wid100 = '100x'
		local wid200 = '200x'
		local wid50 = '50x'
		local tab_wid = '500x300'
		
		lab_name_ = iup.label{title = 'Name : ',rastersize = wid100}
		lab_profile_ = iup.label{title = 'Profile : ',rastersize = wid100}
		lab_material_ = iup.label{title = 'Material : ',rastersize = wid100}

		txt_name_ = iup.text{rastersize = wid200,expand = 'HORIZONTAL'}
		txt_profile_ = iup.text{rastersize = wid200,expand = 'HORIZONTAL'}
		txt_material_ = iup.text{rastersize = wid200,expand = 'HORIZONTAL'}
		
		lab_mode_ = iup.label{title = 'Mode : ',rastersize = wid100}
		list_mode_ = get_list_hwnd(list_mode_data_)
		list_mode_.expand = 'HORIZONTAL'
		
		lab_weight_ = iup.label{title = 'Weight : ',rastersize = wid100}
		txt_weight_ = iup.text{rastersize = wid200,expand = 'HORIZONTAL'}
		
		lab_color_ = iup.label{title = 'Color',rastersize = wid100}
		lab_color_r_ = iup.label{title = 'R : '}
		lab_color_g_ = iup.label{title = 'G : '}
		lab_color_b_ = iup.label{title = 'B : '}
		
		txt_color_r_ = iup.text{rastersize = wid50,}
		txt_color_g_ = iup.text{rastersize = wid50,}
		txt_color_b_ = iup.text{rastersize = wid50,}
		
		local frame_color_ = iup.frame{
				iup.hbox{
					get_tog('Color'),
					lab_color_;
				--	iup.fill{};
					lab_color_r_,
					txt_color_r_,
					iup.fill{};
					lab_color_g_;
					txt_color_g_;
					iup.fill{};
					lab_color_b_;
					txt_color_b_;
					iup.fill{}
				};
			title = 'Color';
		}
		
		lab_length_ = iup.label{title = 'Length',rastersize = wid100}
		txt_length_ = iup.text{rastersize = wid200,expand = 'HORIZONTAL'}
		
		lab_pt_start_ = iup.label{title = 'Start pt : ',rastersize = wid100}
		lab_pt_end_ = iup.label{title = 'End pt : ',rastersize = wid100}
		
		lab_pt_start_x_ = iup.label{title = ' X : '}
		lab_pt_start_y_ = iup.label{title = ' Y : '}
		lab_pt_start_z_ = iup.label{title = ' Z : '}
		
		txt_pt_start_x_ = iup.text{rastersize = wid100,expand = 'HORIZONTAL'}
		txt_pt_start_y_ = iup.text{rastersize = wid100,expand = 'HORIZONTAL'}
		txt_pt_start_z_ = iup.text{rastersize = wid100,expand = 'HORIZONTAL'}
		
		lab_pt_end_x_ = iup.label{title = ' X : '}
		lab_pt_end_y_ = iup.label{title = ' Y : '}
		lab_pt_end_z_ = iup.label{title = ' Z : '}
		
		txt_pt_end_x_ = iup.text{rastersize = wid100,expand = 'HORIZONTAL'}
		txt_pt_end_y_ = iup.text{rastersize = wid100,expand = 'HORIZONTAL'}
		txt_pt_end_z_ = iup.text{rastersize = wid100,expand = 'HORIZONTAL'}
		
		local frame_pt_ = iup.frame{
			iup.vbox{
				iup.hbox{
					get_tog('Spt'),
					lab_pt_start_;
					};
				iup.hbox{
					lab_pt_start_x_,
					txt_pt_start_x_,

					lab_pt_start_y_,
					txt_pt_start_y_,
					lab_pt_start_z_,
					txt_pt_start_z_,
				};
				iup.hbox{
				
					get_tog('Ept'),
					lab_pt_end_;
					--iup.fill{};
					};
				iup.hbox{
					lab_pt_end_x_,
					txt_pt_end_x_,
					lab_pt_end_y_,
					txt_pt_end_y_,
					lab_pt_end_z_,
					txt_pt_end_z_,
				};
			};
			title = 'Points';
		}
		
		lab_alignment_ = iup.label{title = 'Alignment : ',rastersize = wid100}
		lab_horizontal_ = iup.label{title = 'H : '}
		lab_vertical_ = iup.label{title = 'V : '}
		
		list_horizontal_ = get_list_hwnd(list_alignment_h_data_)
		list_vertical_ = get_list_hwnd(list_alignment_v_data_)
		
		
		local frame_alignment = iup.frame{
			iup.hbox{
				get_tog('Alignment'),
				lab_alignment_;
				--iup.fill{};
				lab_horizontal_,
				list_horizontal_,
				iup.fill{};
				lab_vertical_,
				list_vertical_,
				iup.fill{};
			};
			title = 'Alignment';
		}
		
		
		lab_beta_ = iup.label{title = 'Beta : ',rastersize = wid100}
		txt_beta_ = iup.text{rastersize = wid200,expand = 'HORIZONTAL'}
		
		local frame_rotation_ = iup.frame{
			iup.hbox{get_tog('Beta'),lab_beta_,txt_beta_};
			title = 'Rotation';
		}
		
		local frame_mode_ = iup.frame{
			iup.hbox{get_tog('Mode'),lab_mode_,list_mode_};
			title = 'Render Mode';
		}

		local page1 = iup.frame{
			iup.vbox{
				iup.hbox{get_tog('Type'),lab_name_,txt_name_};
				iup.hbox{get_tog('Profile'),lab_profile_,txt_profile_,btn_select_profile_};
				iup.hbox{get_tog('Material'),lab_material_,txt_material_,btn_select_material_};
				iup.hbox{get_tog('Weight'),lab_weight_,txt_weight_};
				iup.hbox{get_tog('Length'),lab_length_,txt_length_};
				
				alignment = 'ALEFT';
			};
			tabtitle = 'Attributes';
			rastersize = tab_wid;
			active = 'no';
		}
		
		local page2 = iup.frame{
			iup.vbox{
				iup.hbox{frame_rotation_};	
				iup.hbox{frame_alignment;};
				iup.hbox{frame_pt_;};	
			};
			expand = 'yes';
			tabtitle = 'Position';
			margin = '5x5';
			rastersize = tab_wid;
			
		}
	
		local page3 = iup.frame{
		
			iup.vbox{
				frame_mode_;
				frame_color_;
			};
			
			expand = 'yes';
			tabtitle = 'Others';
			rastersize = tab_wid;
		}
		
		tab_attr_ = iup.tabs{page1,page2,TABTYPE = 'TOP',expand = 'YES'};
	end

	local function change_tog_val()
		local val = tog_ifo_.state == 'ON' and 'OFF' or 'ON'
		for k,v in ipairs (tog_ifo_) do 
			v.Hwnd.value = val
		end 
		tog_ifo_.state = val
	end 
	
	local function modify_data(cur)
		for k,v in ipairs (tog_ifo_) do 
			if v.Hwnd.value == 'ON' then 
				modify_cmd_[v.Title](cur)
			end 
		end 
	end 
	
	local function deal_ok_action()
		for k,v in pairs (curs) do 
			modify_data(v)
			v:update_data();
			require"sys.mgr".add(v);
			require"sys.mgr".draw(v);
		end 
		require"sys.mgr".update();
		
		
	end 

	local function init_callback()
		function tog_on_:valuechanged_cb()
			if self.value == 'OFF' then 
				self.value = 'ON'
				change_tog_val()
			end 
		end
		
		function tog_off_:valuechanged_cb()
			if self.value == 'ON' then 
				self.value = 'OFF'
				change_tog_val()
			end 
		end
		
		function btn_modify_:action()
			deal_ok_action()
		end
		
		function btn_ok_:action()
			deal_ok_action()
			dlg_:hide()
			exist_dlg_ = nil
		end
		
		function btn_cancel_:action()
			dlg_:hide()
			exist_dlg_ = nil
		end
		
		function dlg_:close_cb()
			exist_dlg_ = nil
		end
	end

	local function init_dlg()
		dlg_  = iup.dialog{
			iup.vbox{
				tab_attr_;
				iup.hbox{tog_frame_,btn_modify_,btn_ok_,btn_cancel_};
				alignment = 'ARIGHT';
				margin = '10x10';
			};
			title = 'Properties';
		}
	end
	
	local function get_alignment_val(h,v)
		local cmd = {}
		cmd['L'] = 0.5
		cmd['C'] = 0
		cmd['R'] = -0.5
		cmd['T'] = 0.5
		cmd['B'] = -0.5
		return cmd[h],cmd[v]
	end
	
	local function get_alignment_data(str)
		if string.sub(str,1,1) == 'C' then 
			return get_alignment_val('C',string.sub(str,7,7))
		elseif string.sub(str,1,1) == 'L' then 
			return get_alignment_val('C',string.sub(str,5,5))
		elseif string.sub(str,1,1) == 'R' then 
			return get_alignment_val('C',string.sub(str,6,6))
		end
	end 
	
	local function get_length(pts)
		local x1,y1,z1,x2,y2,z2 = pts[1].x or pts[1][1], pts[1].y or pts[1][2] ,pts[1].z or pts[1][3] ,pts[2].x or pts[2][1],pts[2].y or pts[2][2],pts[2].z or pts[2][3]
		return math.abs(math.sqrt( math.pow((x1-x2),2) + math.pow((y1-y2),2) + math.pow((z1-z2),2)))
	end
	
	local function init_datas()
	
		--require 'sys.table'.totrace(cur)
		local data = cur
		if data.Color then 
			txt_color_r_.value = data.Color.r or data.Color[1] 
			txt_color_g_.value = data.Color.g or data.Color[2] 
			txt_color_b_.value = data.Color.b or data.Color[3] 
		end 
		
		if data.Points then 
			txt_pt_start_x_.value = data.Points[1].x or data.Points[1][1]
			txt_pt_start_y_.value = data.Points[1].y or data.Points[1][2]
			txt_pt_start_z_.value = data.Points[1].z or data.Points[1][3]
			
			txt_pt_end_x_.value = data.Points[2].x or data.Points[2][1]
			txt_pt_end_y_.value = data.Points[2].y or data.Points[2][2]
			txt_pt_end_z_.value = data.Points[2].z or data.Points[2][3]
		end 
		
		data.Alignment = data.Alignment or {0,0}
		if data.Alignment then 
			--local hor,ver = get_alignment_data(cur.Info.Text.Alignment)
			local hor,ver = data.Alignment.h or  data.Alignment[1],data.Alignment.v or  data.Alignment[2]
			for k,v in ipairs (list_alignment_h_data_) do 
				if list_alignment_h_data_[v] and list_alignment_h_data_[v] == tonumber(hor) then 
					list_horizontal_.value = k
					break
				end  
				
			end 
			
			for k,v in ipairs (list_alignment_v_data_) do 
				if list_alignment_v_data_[v] and list_alignment_v_data_[v] == tonumber(ver) then 
					list_vertical_.value = k
					break
				end  
			end
		end 
		data.Mode = data.Mode or 'Rendering'
		if data.Mode then 
			for k,v in ipairs (list_mode_data_) do 
				if v == data.Mode then 
					list_mode_.value = k
					break;
				end 
			end 
		end 
		data.Beta = data.Beta or 0
		if data.Beta then 
			txt_beta_.value = data.Beta 
		end
	
		data.name = data.name or 'Beam'
		if  data.name then 
			txt_name_.value = data.name
		end
		
		if data.Section then 
			txt_profile_.value = data.Section
		end
		
		if data.Info and data.Info.Text and data.Info.Text.Section then 
			txt_profile_.value = data.Info.Text.Section
		end 
		
		 
		
		if data.material then 
			txt_material_.value = data.material
		end 
		
		txt_length_.value = data.Length or get_length(data.Points)
	
		txt_weight_.value = data.weight 
		
	end 

	local function init()
		
		init_buttons()
		init_controls()
		
		init_datas()
		init_dlg()
		init_callback()
		exist_dlg_ = dlg_
	end
	
	init() 
	dlg_:show()
	
	
	 
end


----pop{Type = 'BEAM'}

