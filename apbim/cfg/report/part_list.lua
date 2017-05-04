
function Single_Length(k,v,t)
	return v.Length;
end

function All_Length(k,v,t)
	return v.Length * v.Count;
end

function Single_Weight(k,v,t)
	return v.Weight;
end

function All_Weight(k,v,t)
	return v.Weight * v.Count;
end

function Single_Weight(k,v,t)
	return v.Price;
end

function All_Price(k,v,t)
	return v.Price * v.Count;
end

function Sort_By_Mat_Section(k1,k2,t)
	if tostring(t[k1].Mat)<tostring([k2].Mat) then
		return true
	elseif tostring(t[k1].Mat)>tostring([k2].Mat) then
		return false
	elseif tostring(t[k1].Section)<tostring([k2].Section)
		return true
	else 
		return false
	end
end
