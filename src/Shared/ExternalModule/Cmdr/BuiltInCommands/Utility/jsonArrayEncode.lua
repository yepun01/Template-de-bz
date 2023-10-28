local HttpService = game:GetService("HttpService")

return {
	Name = "json-array-encode";
	Aliases = {};
	Description = "Encodes a comma-separated list into a JSON array";
	Group = "Utility";
	Args = {
		{
			Type = "string";
			Name = "CSV";
			Description = "The comma-separated list"
		},
	};

	Run = function(_, text)
		return HttpService:JSONEncode(text:split(","))
	end
}