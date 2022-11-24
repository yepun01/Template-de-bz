local Client = {}
Client.__index = {}

function Client:Initialize()
	self.RemoteEvent.OnClientEvent:Connect(function(channelName, event, ...)
		self:Emit(channelName, event, ...)
	end)
end

function Client:FireServer(event, ...)
	self.RemoteEvent:FireServer(self.Channel, event, ...)
end

function Client:InvokeServer(event, ...)
	return self.RemoteFunction:InvokeServer(self.Channel, event, ...)
end

return Client