
local M = {}
local modname = ...
_G[modname] = M
package.loaded[modname] = M
_ENV = M

local obj_ ;

function init()
	obj_ = {
		Diagram = {
			surfaces = {};
		};
		Wireframe = {
			surfaces = {};
		};
		Rendering = {
			surfaces = {};
		};
	}
end

function add_line_surface(line)
	table.insert(obj_.Wireframe.surfaces,line)
end

function add_face_surface(face)
	table.insert(obj_.Rendering.surfaces,face)
end

function endof()
	require 'sys.table'.tofile{file = 'd:/tree.lua',src = obj_}
end
