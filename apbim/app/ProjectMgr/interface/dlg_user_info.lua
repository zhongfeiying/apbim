
local require  = require 
local package_loaded_ = package.loaded
local load = nil
local M = {}
local modname = ...
_G[modname] = M
package_loaded_[modname] = M
_ENV = M

local language_package_ = {
	support_ = {English = 'English',Chinese = 'Chinese'};
	close = {English = 'Close',Chinese = '关闭'};
	change = {English = 'Change',Chinese = '修改'};
	name = {English = 'Name : ',Chinese = '用户 ：'};
	pwd = {English = 'Password : ',Chinese = '密码 ：'};
	mail = {English = 'Mail : ',Chinese = '邮件 ：'};
	pwd = {English = 'Phone : ',Chinese = '电话 ：'};
	--pwd = {English = 'Company : ',Chinese = '个人信息 ：'};
} 


local dlg_;
local lab_wid = '70x'
local lab_name_ = iup.label{rastersize = lab_wid}
local lab_mail_ = iup.label{rastersize = lab_wid}
local lab_pwd_ = iup.label{rastersize = lab_wid}
local lab_phone_ = iup.label{rastersize = lab_wid}
local lab_note_ = iup.label{rastersize = lab_wid}
