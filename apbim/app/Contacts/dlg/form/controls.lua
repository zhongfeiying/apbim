_ENV = module(...,ap.adv)

--arg = {Title,Flat,Wid,}
function get_btn_contorls(arg)
	return iup.button{
		title = arg.Title,--����
		rastersize = arg.Wid,--���ش�С
		FLAT= arg.Flat, --�Ƿ����������͵�btn������label��������껮��ʱ�������ʾ����ť
		Expand = arg.Expand,--��չ����
		}
end


--arg = {Wid,Expand,}
function get_txt_contorls(arg)
	return iup.text{
		rastersize = arg.Wid, --���ش�С
		Expand= arg.Expand,--��չ����
		}
end

function get_lab_contorls(arg)
	return iup.label{
		title = arg.Title,--����
		rastersize = arg.Wid,--���ش�С--�Ƿ����������͵�btn������label��������껮��ʱ�������ʾ����ť
		Expand = arg.Expand,--��չ����
		}
end

function get_matrix_contorls(arg)
	return iup.matrix{
		rastersize = arg.Wid,--���ش�С--�Ƿ����������͵�btn������label��������껮��ʱ�������ʾ����ť
		Expand = arg.Expand,--��չ����
		READONLY = arg.ReadOnly, --wenben zhidu
		numlin = Numlin
		}
end