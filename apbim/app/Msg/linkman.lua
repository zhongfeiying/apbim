_ENV = module(...,ap.adv)

function get_selection_user()
	return {name=require'app.Contacts.interface'.get_selected()};
end

