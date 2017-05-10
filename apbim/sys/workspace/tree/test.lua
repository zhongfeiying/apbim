local tree_ =  require 'sys.tree'
local file = 'c.lua'

local id = tree_.loaded(file)
local iuptree = tree_.get_element(id)

local data = {}
local id = tree_.loaded(data)
local iuptree = tree_.get_element(id)

dlg = iup.dialog{
	iuptree;
}

dlg:popup()