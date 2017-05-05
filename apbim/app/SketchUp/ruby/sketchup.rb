
#炸开模型
mod = Sketchup.active_model
$space = "\t"

File.open("d:/sketchup.lua","w+") do |file|
	entities = mod.entities
	count = entities.count
	file.puts "sketchupInformation ={"
	file.puts "#{$space}count =#{count}"
	file.puts "}"
	def check_entities (var,file)
	# puts " #{var.count} "
# =begin
		var.each  do |entity|
			typename = entity.typename
			if typename  == 'Face' then
				file.puts "Face{"		
				file.puts "#{$space}loops  = {"
				loops  = entity.loops 
				loops .each  do |loop|
				# file.puts "#{$space}#{$space}{"
					file.puts "#{$space}#{$space}{"
					file.puts "#{$space}#{$space}#{$space}isouter = '#{ loop.outer? }';"
					loop_vertrixs = loop.vertices
					loop_vertrixs .each  do |vertrix|
						file.puts "#{$space}#{$space}#{$space}{key = '#{vertrix}',pt = '#{vertrix.position}',};"
					end
					file.puts "#{$space}#{$space}};"
				end
				file.puts "#{$space}},"
				material = entity.material
				if material
					file.puts "#{$space}material  = {"
					color = material.color
					if color 
						if color.red
							file.puts "#{$space}#{$space}color   = {r = #{color.red/255.0},g = #{color.green/255.0},b = #{color.blue/255.0}},"
						end
					end 
					if material.materialType
						file.puts "#{$space}#{$space}materialType  ='#{material.materialType}',"
					end
					texture = material.texture
					if texture
						
						file.puts "#{$space}#{$space}texture  = '#{texture}',"
					end
					# file.puts "#{$space}#{$space}use_alpha  =#{material.use_alpha?}," #是否透明
					if material.use_alpha? 
						file.puts "#{$space}#{$space}alpha_value  ='#{material.alpha }',"
					end
					# file.puts "#{$space}#{$space}texture  =#{material.texture},"
					
					file.puts "#{$space}},"
				end
				file.puts "};"
			elsif typename  == 'Group' then
				groupEntities = entity.entities
				check_entities groupEntities,file
			elsif typename  == 'ComponentInstance' then
				array  = entity.explode
				check_entities array,file
			# elsif typename  == 'EdgeUse' then
				# face = entity.face
			# elsif typename  == 'Edge' then
			else 
				file.puts "TypeName('#{typename}')"
				# puts "TypeName : ('#{typename}')"
			end	
		end
	end
	
	check_entities entities,file
	
end

