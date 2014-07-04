dbg = {}

function dbg.debug(message)
	-- print a debug message. These will be suppressed in release builds.
	local t = debug.getinfo(2) or debug.getinfo(3)
	local location = (t.source or '?') .. ":" .. (t.currentline or '?')
	print("[D:" .. location .. "] " .. message)
end

function dbg.info(message)
	-- print an info message. Always printed.
	local t = debug.getinfo(2) or debug.getinfo(3)
	local location = (t.source or '?') .. ":" .. (t.currentline or '?')
	print("[I:" .. location .. "] " .. message)
end

function dbg.warn(message)
	-- print a warning, but continue execution.
	-- prints line number.
	local t = debug.getinfo(2) or debug.getinfo(3)
	local location = (t.source or '?') .. ":" .. (t.currentline or '?')
	print("[W:" .. location .. "] " .. message)
end

function dbg.err(message)
	-- print error, then forcefully terminates the game.
	-- prints line number.
	local t = debug.getinfo(2) or debug.getinfo(3)
	local location = (t.source or '?') .. ":" .. (t.currentline or '?')
	print("[E:" .. location .. "] " .. message)
	os.exit(1)
end

function dbg.assert(condition, message)
	-- assert a condition to be true.
	-- program is terminated otherwise.
	if not condition then
		dbg.err("Assertion '" .. message .. "' failed!")
	end
end
