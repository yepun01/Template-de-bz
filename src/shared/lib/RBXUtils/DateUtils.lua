local DateUtils = {}

function DateUtils:convertToHMS(Seconds)
    local function Format(Int)
        return string.format("%02i", Int)
    end

	local Minutes = (Seconds - Seconds%60)/60
	Seconds = Seconds - Minutes*60
	local Hours = (Minutes - Minutes%60)/60
	Minutes = Minutes - Hours*60
	return Format(Hours)..":"..Format(Minutes)..":"..Format(Seconds)
end

function DateUtils:convertToDHMS(Seconds)
    local function Format(Int)
        return string.format("%02i", Int)
    end

	local Minutes = (Seconds - Seconds%60)/60
	Seconds = Seconds - Minutes*60
	local Hours = (Minutes - Minutes%60)/60
	Minutes = Minutes - Hours*60
    local Days = (Hours - Hours%24)/24
    Hours = Hours - Days*24
	return Format(Days)..":"..Format(Hours)..":"..Format(Minutes)..":"..Format(Seconds)
end

return DateUtils