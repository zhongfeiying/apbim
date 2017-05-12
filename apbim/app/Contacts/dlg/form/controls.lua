_ENV = module(...,ap.adv)

--arg = {Title,Flat,Wid,}
function get_btn_contorls(arg)
	return iup.button{
		title = arg.Title,--名称
		rastersize = arg.Wid,--像素大小
		FLAT= arg.Flat, --是否是隐藏类型的btn，类似label，但是鼠标划过时会出现显示出按钮
		Expand = arg.Expand,--扩展类型
		}
end


--arg = {Wid,Expand,}
function get_txt_contorls(arg)
	return iup.text{
		rastersize = arg.Wid, --像素大小
		Expand= arg.Expand,--扩展类型
		}
end

function get_lab_contorls(arg)
	return iup.label{
		title = arg.Title,--名称
		rastersize = arg.Wid,--像素大小--是否是隐藏类型的btn，类似label，但是鼠标划过时会出现显示出按钮
		Expand = arg.Expand,--扩展类型
		}
end

function get_matrix_contorls(arg)
	return iup.matrix{
		rastersize = arg.Wid,--像素大小--是否是隐藏类型的btn，类似label，但是鼠标划过时会出现显示出按钮
		Expand = arg.Expand,--扩展类型
		READONLY = arg.ReadOnly, --wenben zhidu
		numlin = Numlin
		}
end