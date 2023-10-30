_addon.author = 'Mapi';
_addon.name = 'Raffle Watch';
_addon.version = '3.6.9.000 Beta';

require 'common';
require 'imguidef';

local variables = {
  ['Rolls']          = { nil, ImGuiVar_CDSTRING, 64 },
  ['var_ShowTestWindow_misc_list1']                   = { nil, ImGuiVar_INT32, 1 },
};

local player_data ={
  ['User'] = {'Mapi','Napi','Minimapi'} ,
  ['Roll'] = {234,434,543} ,
  ['Count'] = 3
};

local raffle_data = {
  Mapi = 123 ,
  Napi = 345,
  MiniMapi = 356
};

local count = 0;
local user_name ='';
local user_roll = 0;
local raffle_status = false;
local listbox_items = 'Empty';
function  SendCmd(command)
  AshitaCore:GetChatManager():QueueCommand(command, 1);
end;



function Get_User(msg_in)
  local msg = msg_in;
  local userIndex = string.find(msg,"roll!");
  local userEndIndex = string.find(msg," rolls ");
  local userName = string.sub(msg,userIndex + 6,userEndIndex-1);
  --print(userName);
  return userName;
end



function Get_Roll(msg_in)
  local msg = msg_in;
  local roll;
  for t in string.gmatch(msg,'[%d]+') do    -- Get Number Rolled
     roll= t;
  end;
  --print(roll);
  return tonumber(roll);
end;

function HighRoll()
  local high_num = 0 ;
  local high_roller=0 ;
  for user, roll in ipairs(player_data['Roll']) do
    --print(string.format('[%s] [%d]',user,tonumber(roll)));
    if(roll>=high_num) then
      high_num=roll;
      high_roller=user;
    end
    --print(r);
    --print(string.format( "%s %d",player_data['User'][user],tonumber(player_data['Roll'][user])));
    --print(string.format('[%s] [%d]',user,tonumber(roll)));
  end;
  --print(string.format("High Roll:%d",value));
  local tmp_msg = string.format('Winner is [%s] with [%d]',player_data['User'][high_roller],high_num);
  --local tmp_msg = 'Winner is: ' .. player_data['User'][high_index] .. ' They Rolled; ' .. player_data['Roll'][high_index];
  return tmp_msg;
end;

ashita.register_event('incoming_text', function(mode, message, modifiedmode, modifiedmessage, blocked)
  local msg = string.strip_colors(message);
  if(string.find(msg,"Dice roll!") and mode == 121 ) then
    local user,roll;  
    
    user = Get_User(msg); --Get User from message
    roll = Get_Roll(msg); --Get Roll from message
    --print(string.format("[%s:%d]",user,roll)); --Debug
    table.insert(player_data['User'],user);
    table.insert(player_data['Roll'],roll);
    
    player_data['Count'] = player_data['Count']+1; --how many users
    --print(player_data['Count']); Debug
    --string.format('%s %d %d',player_data['User'][1],player_data['Roll'][1],player_data['Count']);
  end;
  return false;
end);


ashita.register_event('load', function()
  -- Initialize the custom variables..
  for k, v in pairs(variables) do
      if (v[2] >= ImGuiVar_CDSTRING) then 
          variables[k][1] = imgui.CreateVar(variables[k][2], variables[k][3]);
      else
          variables[k][1] = imgui.CreateVar(variables[k][2]);
      end
      if (#v > 2 and v[2] < ImGuiVar_CDSTRING) then
          imgui.SetVarValue(variables[k][1], variables[k][3]);
      end        
  end
end);

ashita.register_event('command', function(command, ntype)
    -- Get the command arguments..
	cmd_count=0;
	local args = command:args();
  local cmd = args[1];
	local cmd = cmd:lower();
	return false;
end ); -- End Command

ashita.register_event('render', function()
  
  if (imgui.Begin('Raffle Watch') == false) then
      -- Early out if the window is collapsed, as an optimization..
      imgui.End();
      return;
  end;
  if(raffle_status) then
    if(imgui.Button("Stop")) then
      raffle_status = false;
    end;
  else
    if(imgui.Button("Start")) then
      raffle_status = true;
    end;
    
  end;
  imgui.SameLine();
    if(imgui.Button("Random"))then
    SendCmd("/random");
  end;
  imgui.SameLine();
  if(imgui.Button("Reload"))then
    SendCmd("/addon reload raffle");
  end
  imgui.SameLine();
  if(imgui.Button("Winner"))then
    --print(HighRoll());
    local msg = HighRoll();
    SendCmd("/echo Unofficial Results:" .. msg);
  end;
  if(imgui.Button("Clear"))then
    player_data ={
      ['User'] = {} ,
      ['Roll'] = {} ,
      ['Count'] = 0
    };
    imgui.SetVarValue(variables['Rolls'][1],'');
  end;
  if(imgui.Button("Exit"))then
    SendCmd("/addon unload raffle");
  end
 
  --imgui.InputTextMultiline("Rolls",variables['Rolls'][1],64);
  imgui.ListBoxHeader("Rolls");
  local high_num = 0 ;
  local high_roller=0 ;
    for value, roll in ipairs(player_data['User']) do
      --print(raffle_data[user]);
      
      for user, roll in ipairs(player_data['Roll']) do
        if(roll>=high_num) then
          high_num=roll;
          high_roller=user;
        end
      end;
      if(player_data['Roll'][value]==high_num) then
        imgui.PushStyleColor( ImGuiCol_Text,0.156, 0.907, 0.920, 1);
      else
        imgui.PushStyleColor( ImGuiCol_Text,0.869,0.920,0.156, 1);
        
      end;
      imgui.Selectable(string.format("%s %d",player_data['User'][value],player_data['Roll'][value]),false);
      imgui.PopStyleColor();
    end;
    
  imgui.ListBoxFooter();
  --imgui.
  imgui.End();
  
end); --End Render