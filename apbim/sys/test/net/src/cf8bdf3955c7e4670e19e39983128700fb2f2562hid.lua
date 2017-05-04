ap_set_msg_id("39Ws$1QRX5MgxgY36HMEcn") 
ap_set_msg_name("ALL") 
ap_set_msg_text("") 
ap_set_msg_from("BETTER") 
ap_set_msg_to("tbj") 
ap_set_msg_send_time(1463563528) 
ap_send_arrived_report("39Ws$1QRX5MgxgY36HMEcn","BETTER") 
ap_set_msg_read_cbf(function() ap_send_read_report("39Ws$1QRX5MgxgY36HMEcn","BETTER") end) 
ap_set_msg_confirm_cbf(function(arg) ap_send_confirm_report("39Ws$1QRX5MgxgY36HMEcn","BETTER",arg) end) 
local function f() 
ap_this_msg().Project_id =  "22nyTZtOv7xOhI5bTH99Re"
ap_this_msg().Files=ap_this_msg().Files or {}  
end 
f()
