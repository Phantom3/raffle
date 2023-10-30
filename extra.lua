ashita.register_event('incoming_text', function(mode, message, modifiedmode, modifiedmessage, blocked)
  local msg = string.strip_colors(message);
    --Dice roll! User rolls xxx!

  if(string.find(msg,"Dice roll!") and mode == 121 ) then
    local count = 1;
    local roll = '';
    local tmp = ''
    local user = '';
    local ur = '';
    roll = roll  .. imgui.GetVarValue(variables['Rolls'][1]);
    for token in string.gmatch(msg,'[^%s]+') do
      if (count==3) then
        user = token;
      elseif(count==5) then
        ur=token;
      end;
      count=count+1;
    end;
    count=1;
    for i, v in ipairs(User_rolls) do
      count=count+1
      
    end
    table.insert(User_rolls,count,user);
    User_rolls[count]=ur;
    --print(User_rolls[count]);
    
    local tmp_rolls = table.concat(User_rolls,'\n');
    print(tmp_rolls);
    
    imgui.SetVarValue(variables['Rolls'][1],tmp_rolls);
    return false;
  end;
  return false;
end);



----------------------------------------------------------------------------------------------------
ashita.register_event('incoming_text', function(mode, message, modifiedmode, modifiedmessage, blocked)
  local msg = string.strip_colors(message);
    --Dice roll! User rolls xxx!
  if(raffle_status) then
    if(string.find(msg,"Dice roll!") and mode == 121 ) then
      local tmp_token;
      player_data['Count'] = player_data['Count'] + 1;
      print(string.format("P_Count:%d",player_data['Count']));
      local user_count=0;
      token_count = 1;
    
      for token in string.gmatch(msg,'[^%s]+') do
        if (token_count==3) then
          table.insert(player_data['User'],token);
          --print(string.format("User: %s",token));
        elseif(token_count==5) then
          tmp_token = token:gsub('[%p]','')
          tmp_token = tonumber(tmp_token);
          table.insert(player_data['Roll'],tmp_token);
          --print(string.format("Rolled:%d",tmp_token));
        end;
      end;
      
      for i, v in ipairs(player_data['User']) do
        user_count = user_count + 1
      end;
      player_count = player_data['Count'];
      print(string.format("User: %s\nRolled:%d",player_data['User'][player_count],player_data['Roll'][player_count]));
      tmp_data = imgui.GetVarValue(variables['Rolls'][1]);
      tmp_data = tmp_data .. player_data['User'][player_count] .. ' ' .. player_data['Roll'][player_count] .. '\n';
      print(tmp_data);
      imgui.SetVarValue(variables['Rolls'][1],tmp_data);
      return false;
    end;
  end;
return false;
end);



function Get_User(msg_in)
  local msg = msg_in;
  msg = string.gsub(msg,"Dice roll! ","");  -- Remove Unwanted data from msg
  msg = string.gsub(msg,"rolls","");        -- Remove Unwanted data from msg
  for t in string.gmatch(msg,'[%d]+') do    -- Get Number Rolled
    troll = t;
  end
  msg = string.gsub(msg,'[%d]+','');       -- Remove Number data from msg
  msg = string.gsub(msg,'[%s]+','');        -- Remove spaces data from msg
  msg = string.gsub(msg,'[%p]+','');        -- Remove Unwanted data from msg
    
  return msg;
end