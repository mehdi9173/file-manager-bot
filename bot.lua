package.path = package.path .. ';.luarocks/share/lua/5.2/?.lua'
  ..';.luarocks/share/lua/5.2/?/init.lua'
package.cpath = package.cpath .. ';.luarocks/lib/lua/5.2/?.so'
URL = require('socket.url')
JSON = require('dkjson')
HTTPS = require('ssl.https')
clr = require 'term.colors'
sudo_users = {@if_i_was_good} --------------Youre id
local bot_api_key = "338327518:AAHWO6Pk6KeAWwEoFy8NJ7jLjk-kKCoVErY" --------------Youre bot token
local BASE_URL = "https://api.telegram.org/bot"..bot_api_key
local BASE_FOLDER = ".."
function is_sudo(msg)
  local var = false
  for k,v in pairs(sudo_users) do
    if msg.from.id == v then
      var = true
    end
  end
  return var
end
function vardump(value, depth, key)
  local linePrefix = ''
  local spaces = ''

  if key ~= nil then
    linePrefix = key .. ' = '
  end

  if depth == nil then
    depth = 0
  else
    depth = depth + 1
    for i=1, depth do 
      spaces = spaces .. '  '
    end
  end

  if type(value) == 'table' then
    mTable = getmetatable(value)
    if mTable == nil then
      print(spaces .. linePrefix .. '[ ')
    else
      print(spaces .. '] ')
        value = mTable
    end
    for tableKey, tableValue in pairs(value) do
      vardump(tableValue, depth, tableKey)
    end
  elseif type(value)  == 'function' or 
    type(value) == 'thread' or 
    type(value) == 'userdata' or 
    value == nil then
      print(spaces .. tostring(value))
  elseif type(value)  == 'string' then
    print(spaces .. linePrefix .. '"' .. tostring(value) .. '",')
  else
    print(spaces .. linePrefix .. tostring(value) .. ',')
  end
end

function sendRequest(url) 
local dat,code = HTTPS.request(url)
if not dat then 
sendMessage(185532812, 'Error.url : \n'..url..'\n\nCode : '..code)---------- 185532812 پاک کنید و آیدی خود را در جای آن قرار دهید 
return false, code  
end 
local tab = JSON.decode(dat)  
if not tab.ok then 
vardump(tab)
sendMessage(185532812, 'Error.url : \n'..url..'')---------- 185532812 پاک کنید و آیدی خود را در جای آن قرار دهید 
return false
end 
return tab 
end 
function getMe()
    local url = BASE_URL .. '/getMe'
  return sendRequest(url)
end
function getUpdates(offset)
  local url = BASE_URL .. '/getUpdates?timeout=20'
  if offset then
    url = url .. '&offset=' .. offset
  end
  return sendRequest(url)
end
function sendMessage(chat_id, text, disable_web_page_preview, reply_to_message_id, use_markdown,key)
	local url = BASE_URL .. '/sendMessage?chat_id=' .. chat_id .. '&text=' .. URL.escape(text)
	if disable_web_page_preview == true then
		url = url .. '&disable_web_page_preview=true'
	end
	if key then 
url = url..'&reply_markup='..JSON.encode(key) 
end
	if reply_to_message_id then
		url = url .. '&reply_to_message_id=' .. reply_to_message_id
	end
	if use_markdown then
		url = url .. '&parse_mode=Markdown'
	end
	return sendRequest(url)
end
local function editMessageText(mode, message_id, chat_id, text, keyboard, markdown) 
if mode == 'inline' then 
 url = BASE_URL .. '/editMessagetext?inline_message_id='..message_id..'&text=' ..  URL.escape(text)
else 
 url = BASE_URL .. '/editMessagetext?chat_id='..chat_id..'&message_id='..message_id..'&text=' ..  URL.escape(text)
end 
if markdown then 
url = url .. '&parse_mode=Markdown' 
end 

url = url .. '&disable_web_page_preview=true' 
 
if keyboard then 
url = url..'&reply_markup='..JSON.encode(keyboard) 
end 
print(url) 
local res, code = sendRequest(url) 
return res, code  
end  
function sendDocument(chat_id, document, reply_to_message_id)
	local url = BASE_URL .. '/sendDocument'
	local curl_command = 'cd \''..BASE_FOLDER..currect_folder..'\' && curl -s "' .. url .. '" -F "chat_id=' .. chat_id .. '" -F "document=@' .. document .. '"'
	if reply_to_message_id then
		curl_command = curl_command .. ' -F "reply_to_message_id=' .. reply_to_message_id .. '"'
	end
	io.popen(curl_command):read("*all")
	return
end
function download_to_file(url, file_name, file_path)
  print("url to download: "..url)
  local respbody = {}
  local options = {
    url = url,
    sink = ltn12.sink.table(respbody),
    redirect = true
  }
  local response = nil
    options.redirect = false
    response = {HTTPS.request(options)}
  local code = response[2]
  local headers = response[3]
  local status = response[4]
  if code ~= 200 then return nil end
  local file_path = BASE_FOLDER..currect_folder..file_name
  print("Saved to: "..file_path)
  file = io.open(file_path, "w+")
  file:write(table.concat(respbody))
  file:close()
  return file_path
end
function bot_run()
  bot = nil
  if not bot then
    bot = getMe()
  end
  bot = bot.result
  local bot_info = "Username : @"..bot.username.."\nName : "..bot.first_name.."\nId : "..bot.id.."\nRun : "..os.date("%F - %H:%M:%S")
  print(bot_info)
  for k,v in pairs(sudo_users) do
sendMessage(v, bot_info, true, 0, true)
end
 print(clr.green.."██████████████    ██████████████  ██████████████████    ██████          ██████  ██████████████  ████████  ████████")
 print(clr.green.."██          ██    ██          ██  ██              ██    ██  ██████████  ██  ██  ██          ██  ██    ██  ██    ██")
 print(clr.green.."██  ██████  ██    ██  ██████  ██  ████████  ████████    ██          ██  ██  ██  ██  ██████████  ████  ██  ██  ████")
 print(clr.green.."██  ██  ██  ██    ██  ██  ██  ██        ██  ██          ██  ██████  ██  ██  ██  ██  ██            ██    ██    ██  ") 
 print(clr.white.."██  ██████  ████  ██  ██  ██  ██        ██  ██          ██  ██  ██  ██  ██  ██  ██  ██████████    ████      ████  ")
 print(clr.white.."██            ██  ██  ██  ██  ██        ██  ██          ██  ██  ██  ██  ██  ██  ██          ██      ██      ██    ") 
 print(clr.white.."██  ████████  ██  ██  ██  ██  ██        ██  ██          ██  ██  ██  ██  ██  ██  ██  ██████████    ████      ████  ") 
 print(clr.white.."██  ██    ██  ██  ██  ██  ██  ██        ██  ██          ██  ██  ██  ██████  ██  ██  ██            ██    ██    ██  ") 
 print(clr.red.."██  ████████  ██  ██  ██████  ██        ██  ██          ██  ██  ██          ██  ██  ██████████  ████  ██  ██  ████") 
 print(clr.red.."██            ██  ██          ██        ██  ██          ██  ██  ██████████  ██  ██          ██  ██    ██  ██    ██") 
 print(clr.red.."████████████████  ██████████████        ██████          ██████          ██████  ██████████████  ████████  ████████") 
  last_update = last_update or 0
  is_running = true
  currect_folder = " "
end
function string:split(sep)
  local sep, fields = sep or ":", {}
  local pattern = string.format("([^%s]+)", sep)
self:gsub(pattern, function(c) fields[#fields+1] = c end)
return fields
end
function msg_processor(msg)
	if msg == nil then return end
	if not is_sudo(msg) then return end
	if msg.date < os.time() - 5 then 
		return
	end
	if msg.text then
		if msg.text:match("^ls$") or msg.text:match("^/ls$") then
		local matches = { string.match(msg.text, "^ls$") }
			local action = io.popen('ls "'..BASE_FOLDER..currect_folder..'"'):read("*all")
			local tabs = action:split('\n')
			local key = {}
			key.inline_keyboard = {}
			for i = 1,#tabs do
			 button = {{text = i..'-'..tabs[i],callback_data = 'cd '..tabs[i]}}
             table.insert(key.inline_keyboard, button)
			end
			sendMessage(msg.chat.id, action, true, false, true,key)
    end
	if msg.text:match("^cd$") or msg.text:match("^/cd$") then
		local matches = { string.match(msg.text, "^cd$") }
			local action = io.popen('ls -p "'..BASE_FOLDER..currect_folder..'"'):read("*all")
			local tabs = action:split('\n')
			local key = {}
			key.inline_keyboard = {}
			for i = 1,#tabs do
			if tabs[i]:match('/$') then
			 button = {{text = i..'-'..tabs[i],callback_data = 'cd '..tabs[i]:gsub('/','')}}
             table.insert(key.inline_keyboard, button)
			end
			end
			sendMessage(msg.chat.id, '*PLeas Select your dir to go thir*', true, false, true,key)
    end
	if msg.text:match("^dlt$") or msg.text:match("^/dlt$") then
		local matches = { string.match(msg.text, "^dlt$") }
			local action = io.popen('ls -p "'..BASE_FOLDER..currect_folder..'"'):read("*all")
			local tabs = action:split('\n')
			local key = {}
			key.inline_keyboard = {}
			for i = 1,#tabs do
			if not tabs[i]:match('/$') then
			 button = {{text = i..'-'..tabs[i],callback_data = 'rm '..tabs[i]}}
             table.insert(key.inline_keyboard, button)
			end
			end
			sendMessage(msg.chat.id, '*PLeas Select your file to remove it*', true, false, true,key)
    end
	if msg.text:match("^git pull$") or msg.text:match("^/git pull$") then
		local matches = { string.match(msg.text, "^git pull$") }
			local action = io.popen("git pull "):read('*all')
      sendMessage(msg.chat.id, action)
    end
	if msg.text:match("^reboot$") or msg.text:match("^/reboot$") then
		local matches = { string.match(msg.text, "^reboot$") }
			local action = io.popen("sh ./upstart.sh"):read('*a')			
      sendMessage(msg.chat.id, action)
    end
	if msg.text:match("^serverinfo$") or msg.text:match("^/serverinfo$") then
		local matches = { string.match(msg.text, "^serverinfo$") }
			local action = io.popen("sh ./cmd.sh"):read('*a')  
      sendMessage(msg.chat.id, action)
    end
    if msg.text:match("^/cd (.*)$") then
			local matches = { string.match(msg.text, "^/cd (.*)$") }
			currect_folder = '/'..matches[1]
			local tester = io.popen('ls "'..BASE_FOLDER..'"'):read("*all")
			print(tester)
			if not tester:find(matches[1]) then
			currect_folder = ''
			local key = {}
			key.inline_keyboard = {{{text = 'Create folder',callback_data = 'mkdir '..matches[1]}}}
			sendMessage(msg.chat.id, '*I cant Find this Folder \ndo you want create it new😏*', true, false, true,key)
			else
			sendMessage(msg.chat.id, "*Currect folder* _=_ `"..BASE_FOLDER..currect_folder.."`")
			end
    end

    if msg.text:match("^/mkdir (.*)$") then
      local matches = { string.match(msg.text, "^/mkdir (.*)$") }
			local action = io.popen('cd "'..BASE_FOLDER..currect_folder..'" && mkdir \''..matches[1]..'\''):read("*all")
			local key = {}
			key.inline_keyboard = {{{text = 'Go to createed dir',callback_data = 'cd '..matches[1]}}}
			sendMessage(msg.chat.id, "*Created folder\ndo you want go to this folder??*", true, false, true,key)
    end
		if msg.text:match("^/rm (.*)$") then
			local matches = { string.match(msg.text, "^/rm (.*)$") }
			local action = io.popen('cd "'..BASE_FOLDER..currect_folder..'" && rm -f \''..matches[1]..'\''):read("*all")
			sendMessage(msg.chat.id, "*Deleted* `"..matches[1].."`")
		end
		if msg.text:match("^/cat (.*)$") then
			local matches = { string.match(msg.text, "^/cat (.*)$") }
			local action = io.popen('cd "'..BASE_FOLDER..currect_folder..'" && cat \''..matches[1]..'\''):read("*all")
			sendMessage(msg.chat.id, action)
		end
		if msg.text:match("^/rmdir (.*)$") then
			local matches = { string.match(msg.text, "^/rmdir (.*)$") }
			local action = io.popen('cd "'..BASE_FOLDER..currect_folder..'" && rmdir \''..matches[1]..'\''):read("*all")
			sendMessage(msg.chat.id, "*Deleted* `"..matches[1].."`")
		end
		if msg.text:match("^/touch (.*)$") then
			local matches = { string.match(msg.text, "^/touch (.*)$") }
			local action = io.popen('cd "'..BASE_FOLDER..currect_folder..'" && touch \''..matches[1]..'\''):read("*all")
			sendMessage(msg.chat.id, "*Created  file* `"..matches[1].."`")
		end
		if msg.text:match("^/tofile ([^%s]+) (.*)$") then
			local matches = { string.match(msg.text, "^/tofile ([^%s]+) (.*)$") }
			local file = io.open(BASE_FOLDER..currect_folder..matches[1], "w")
			file:write(matches[2])
			file:flush()
			file:close()
			sendMessage(msg.chat.id, "*Done!*")
		end
		if msg.text:match("^/shell (.*)$") then
			local matches = { string.match(msg.text, "^/shell (.*)$") }
			local text = io.popen('cd "'..BASE_FOLDER..currect_folder..'" && '..matches[1]:gsub('—', '--')):read('*all')
			sendMessage(msg.chat.id, text)
		end
		if msg.text:match("^/cp (.*) (.*)$") then
			local matches = { string.match(msg.text, "^/cp (.*) (.*)$") }
			local action = io.popen('cd "'..BASE_FOLDER..currect_folder..'" && cp -r \''..matches[1]..'\' \''..matches[2]..'\''):read("*all")
			sendMessage(msg.chat.id, "*Copied file* `"..matches[1].."`")
		end
		if msg.text:match("^/mv (.*) (.*)$") then
			local matches = { string.match(msg.text, "^/mv (.*) (.*)$") }
			local action = io.popen('cd "'..BASE_FOLDER..currect_folder..'" && mv \''..matches[1]..'\' \''..matches[2]..'\''):read("*all")
			sendMessage(msg.chat.id, "*Moved file* `"..matches[1].."`")
		end
		if msg.text:match("^/upload (.*)$") then
			local matches = { string.match(msg.text, "^/upload (.*)$") }
			if io.popen('find '..BASE_FOLDER..currect_folder..matches[1]):read("*all") == '' then
				sendMessage(msg.chat.id, "*File does not exist*")
			else
				sendMessage(msg.chat.id, "*Uploading file* `"..matches[1].."`")
				sendDocument(msg.chat.id, matches[1])
			end
		end
		if msg.text:match("^/start") or msg.text:match("^start") then
    local matches = { string.match(msg.text, "^start$") }
      local text = "*Welcome Youre Bot*"
      local key = {}
     key.inline_keyboard = {{{text = '\nShow command : help', callback_data = 'تست'}}}
	 sendMessage(msg.chat.id, text, true, false, true, key)
	 ------------------------------------------------------------------------
      local key = {}
      key.keyboard = {{{text = 'ls'},{text = 'cd'}},{{text = 'git pull'},{text = 'serverinfo'}},{{text = 'reboot'},{text = 'help'}},{{text = 'dlt'},{text = 'start'}}}
             sendMessage(msg.chat.id, text, true, false, true, key)
             end
	 -------------------------------------------------------------------------
            if msg.text:match("^help") or msg.text:match("^/help") then
			local matches = { string.match(msg.text, "^help$") }
			local text = [[*Commands* _:_

/git pull
`Youre bot update`

/start
`Youre bot started`

/serverinfo
`Specifications youre server`

/cd [folder]
`Open folder`

/ls
`List folders`

/mkdir [folder name]
`Create a folder with name chosen`

/rmdir [folder name]
`Remove the folder chosen`

/rm [file name]
`Remove file`

/touch [file name]
`Create a file with name chosen`

/cat [file name]
`Print the content`

/tofile [file name] [text]
`Will create a file with name [file name] and will put [text] in it`

/shell [command]
`Allow use the [command] on terminal`

/cp [file] [dir]
`Copie [file] to folder [dir]`

/mv [file] [dir]
`Move [file] to folder [dir]`

/upload [file name]
`Will upload that file in current folder`

/download
`will download that file you replied to`
`Bot will select a name automatically`

/download [file name]
`Bot will save file with [file name]`
`Bot can upload files up to 50 mg and download files up to 20 mg`

`You can use "!" or "/" to begin all commands`
]]
			sendMessage(msg.chat.id, text, true, false, true)
         end
		if msg.text:match("^download (.*)$") or msg.text:match("^[!/]download$") then
			if not msg.reply_to_message then
				sendMessage(msg.chat.id, "*Reply to something!*")
				return
			end
			local file = ""
			local filename = ""
			if msg.reply_to_message.photo then
				file = msg.reply_to_message.photo[1].file_id
				filename = "somepic.jpg"
			elseif msg.reply_to_message.video then
				file = msg.reply_to_message.video.file_id
				filename = "somevideo.mp4"
				if msg.reply_to_message.video.file_size > 19000000 then
					return
				end
			elseif msg.reply_to_message.document then
				file = msg.reply_to_message.document.file_id
				filename = msg.reply_to_message.document.file_name
				if msg.reply_to_message.document.file_size > 19000000 then
					return
				end
			elseif msg.reply_to_message.audio then
				filename = msg.reply_to_message.audio.title..".mp3"
				file = msg.reply_to_message.audio.file_id
			elseif msg.reply_to_message.sticker then
				filename = "somevoice.png"
				file = msg.reply_to_message.sticker.file_id
			elseif msg.reply_to_message.voice then
				filename = "somevoice.ogg"
				file = msg.reply_to_message.voice.file_id
			else
				return
			end
			local url = BASE_URL .. '/getFile?file_id='..file
			local res = HTTPS.request(url)
			local jres = JSON.decode(res)
			if string.match(msg.text, "^download (.*)$") then
				local matches = { string.match(msg.text, "^[!/]download (.*)$") }
				filename = matches[1]
			end
			local download = download_to_file("https://api.telegram.org/file/bot"..bot_api_key.."/"..jres.result.file_path, filename)
			sendMessage(msg.chat.id, "*file downloaded*")
		end
	end
	return
end
function on_callback(msg) 
if not msg.data then return nil end
if string.match(msg.data, "^cd (.*)$") then
			local matches = { string.match(msg.data, "^cd (.*)$") }
			currect_folder = '/'..matches[1]
			local tester = io.popen('ls "'..BASE_FOLDER..currect_folder..'"'):read("*all")
			if not tester:find(matches[1]) then
			currect_folder = '/'
			 local key = {}
			key.inline_keyboard = {{{text = 'Create folder',callback_data = 'mkdir '..matches[1]}}}
			local text =  '*I cant Find this Folder..!! do you want create it new*'
			else
			text =  "*Currect folder*"
			end
			editMessageText(mode, msg.message.message_id, msg.message.chat.id, text, key, true)
       end
	end
bot_run() 
while true do 
	local response = getUpdates(last_update+1) 
	if response then
		for i,v in ipairs(response.result) do
		if v.message then
			msg_processor(v.message)
		elseif v.callback_query then
		on_callback(v.callback_query )
		end
		last_update = v.update_id
		end
	else
		print("Conection failed")
	end
end
print("Bot halted")
