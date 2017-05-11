_ENV = module(...)

local hpdf = require"hpdf"

function to_pdf(u3d_file,pdf_file)
	local name = u3d_file
	local pdf = hpdf.New()
	if not pdf then os.exit() end

	local run,close = require"sys.progress".create{title="Save PDF File ...",text=true,time=1}
	hpdf.UseCNSFonts(pdf)
	hpdf.UseCNSEncodings(pdf);
	local font =  hpdf.GetFont(pdf,"SimSun","GBK-EUC-H")
	local page = hpdf.AddPage(pdf)
	hpdf.Page_SetFontAndSize(page, font, 30)
	hpdf.Page_SetWidth(page, 700)
	hpdf.Page_SetHeight(page,920)
	
	run("Load U3D")
	local u3d = hpdf.LoadU3DFromFile(pdf,u3d_file)
	
	run("Create PDF")
	local  code = [[
		scene.renderMode = "solid outline";
		scene.lightScheme = "cad";
		scene.update();
	]]
	local js = hpdf.CreateJavaScript(pdf,code)
	hpdf.U3D_AddOnInstanciate(u3d,js)

	rect = {left = 50,top = 50,right = 650,bottom = 650}
	local annot = hpdf.Page_Create3DAnnot(page,rect,u3d)

	run("Save PDF")
	hpdf.SaveToFile(pdf,pdf_file)
	hpdf.Free(pdf)
	close();
end


