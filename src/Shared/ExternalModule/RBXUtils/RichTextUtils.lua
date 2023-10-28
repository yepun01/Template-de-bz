local RichTextUtils = {}


function Color3tostring(Color)
    local r = Color.R
    local g = Color.G
    local b = Color.B
    return r..","..g..","..b
end

function RichTextUtils.new(txt)
	local this = {class = 'RichTextUtils', text = txt or ''}

	setmetatable(this, {
		__index = this;

		__tostring = function ()
			return this.text
		end;

        __add = function (a, b)
			if type(a) == 'string' or type(b) == 'string' then
				return a == this and this.text .. b or a .. this.text
			elseif type(a) == 'table' and type(b) == 'table' then
				if a.class and b.class and a.class == 'RichTextUtils' and b.class == 'RichTextUtils' then
					return RichTextUtils.new(a.text .. b.text)
				end
			end
		end
	})

	function this:TextScale(str, scale)
        if scale then
			this.text = this.text..'<TextScale='..scale..'>' ..str
		else
			this.text = '<TextScale='..str..'>' .. this.text
		end
		return this
	end

	function this:Align(str, align)
        if align then
			this.text = this.text..'<ContainerHorizontalAlignment='..align..'>' ..str
		else
			this.text = '<ContainerHorizontalAlignment='..str..'>' .. this.text
		end
		return this
	end

	function this:Wait(str, waits)
        if waits then
			this.text = this.text..'<AnimateYield='..waits..'>' ..str
		else
			this.text = '<AnimateYield='..str..'>' .. this.text
		end
		return this
	end

	function this:ClearAnimationStyle(str, waits)
        if waits then
			this.text = this.text..'<AnimateStyle=/>' ..str
		else
			this.text = '<AnimateStyle=/>' .. this.text
		end
		return this
	end

    function this:AnimateStyle(str, anim)
        if anim then
			this.text = this.text..'<AnimateStyle='..anim..'>' .. str
		else
			this.text = '<AnimateStyle='..str..'>' .. this.text
		end
		return this
	end

    function this:AnimateDelay(str, delays)
        if delays then
			this.text = this.text..'<AnimateDelay='..delays..'>' .. str
		else
			this.text = '<AnimateDelay='..str..'>' .. this.text
		end
		return this
	end

	function this:AnimateStyleTime(str, delays)
        if delays then
			this.text = this.text..'<AnimateStyleTime='..delays..'>' .. str
		else
			this.text = '<AnimateStyleTime='..str..'>' .. this.text
		end
		return this
	end

	function this:AnimateStepFrequency(str, delays)
        if delays then
			this.text = this.text..'<AnimateStepFrequency='..delays..'>' .. str
		else
			this.text = '<AnimateStepFrequency='..str..'>' .. this.text
		end
		return this
	end

    function this:Color3(str, color)
        if color then
            local rgb = Color3tostring(color)
			this.text = this.text..'<TextColor3='..rgb..'>' .. str
		else
			local rgb = Color3tostring(str)
			this.text = '<TextColor3='..rgb..'>' .. this.text
		end
		return this
	end

    function this:Font(str, font)
        if font then
			this.text = this.text..'<Font='..font..'>' .. str
		else
			this.text = '<Font='..str..'>' .. this.text
		end
		return this
	end

    function this:Add(str)
		if str then
			this.text = this.text .. str
		else
			this.text = this.text .. ' '
		end
		return this
	end

    return this
end

return RichTextUtils