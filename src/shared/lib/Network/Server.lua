local Server = {}
Server.__index = {}

function Server:Initialize()
	self.RemoteEvent.OnServerEvent:Connect(function(player, channelName, event, ...)
		self:Emit(channelName, event, player, ...)
	end)
	
	self.RemoteFunction.OnServerInvoke = function(player, channelName, event, ...)
		return self:Emit(channelName, event, player, ...)
	end
end

function Server:FireClient(player, event, ...)
	self.RemoteEvent:FireClient(player, self.Channel, event, ...)
end

function Server:FireAllClients(event, ...)
	self.RemoteEvent:FireAllClients(self.Channel, event, ...)
end

function Server:InvokeClient(player, event, ...)
	self.RemoteFunction:FireServer(player, self.Channel, event, ...)
end


return Server