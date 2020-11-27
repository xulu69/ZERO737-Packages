local MasterPanel = script.Parent
local players = game:GetService("Players")
local tweenService = game:GetService("TweenService")
local runService = game:GetService("RunService")

local body = script.Parent.body.Value
local planeParts = body.FOCore.Parent.Parent:GetDescendants()
local FOMain = script.Parent.FOMain.Value


local debounce = false

MasterPanel:TweenPosition(UDim2.new(0.5,0,0.5,0),nil,Enum.EasingStyle.Sine,0.5)

--The below tables contain functions indexed by name, this is so that these functions can be easily categorized and called.


local function ShowIcon () 
	MasterPanel.HideShowPanel.Btn.Text = ("Show")
end
local function HideIcon ()
	MasterPanel.HideShowPanel.Btn.Text = ("Hide")
end;

local function findObject(searchName,tableToBeSearched)
	for i,object in pairs(tableToBeSearched)do
		if object.Name == searchName then
			return object;
		end
	end
end

local GuiFunctions = {
	["animateObject"] = function(uiObject,udim2size,length)
		uiObject:TweenPosition(udim2size,nil,nil,length)
	end;
	
	["hideUI"] = function()
		if debounce == false then
			debounce = true
			for i,child in ipairs(MasterPanel:GetChildren())do
				if child.Name ~= "HideShowPanel" and child ~= script and child:IsA("Frame")then
					child:TweenPosition(UDim2.new(child.Position.X.Scale,child.Position.X.Offset,1.3,0),Enum.EasingDirection.InOut,Enum.EasingStyle.Quint,1,false,ShowIcon())
				elseif child.Name == "HideShowPanel" then
					child:TweenPosition(UDim2.new(child.Position.X.Scale,child.Position.X.Offset,0.9,0),Enum.EasingDirection.InOut,Enum.EasingStyle.Quint,1,false)
				end
			end
			repeat wait() until MasterPanel.CenterPanel.Position == UDim2.new(MasterPanel.CenterPanel.Position.X.Scale,MasterPanel.CenterPanel.Position.X.Offset,1.3,0)
			debounce = false
			print(debounce)
			return ("UIHidden")
		end
	end;
	
	["showUI"] = function()
		if debounce == false then
			debounce = true
			MasterPanel.CenterPanel:TweenPosition(UDim2.new(0.499,0,0.791,0),Enum.EasingDirection.InOut,Enum.EasingStyle.Quint,1)
			MasterPanel.DoorPanel:TweenPosition(UDim2.new(0.85,0,0.772,0),Enum.EasingDirection.InOut,Enum.EasingStyle.Quint,1)
			MasterPanel.SystemPanel:TweenPosition(UDim2.new(0.152,0,0.772,0),Enum.EasingDirection.InOut,Enum.EasingStyle.Quint,1)
			MasterPanel.HideShowPanel:TweenPosition(UDim2.new(0.018,0,0.51,0),Enum.EasingDirection.InOut,Enum.EasingStyle.Quint,1,false,HideIcon())
			repeat wait() until MasterPanel.CenterPanel.Position == UDim2.new(MasterPanel.CenterPanel.Position.X.Scale,MasterPanel.CenterPanel.Position.X.Offset,0.791,0)
			debounce = false
			return ("UIShown")
		end
	end;
	
	["UpdateStats"] = function()
		runService.Heartbeat:Connect(function()
			if body:FindFirstChild("FOCore") then
				local currentSpeed = body.FOCore.Velocity.Magnitude
				local roundedSpeed = math.floor(currentSpeed)
				local stringSpeed = tostring(roundedSpeed)
				MasterPanel.CenterPanel.Spd.TextLabel.Text = (stringSpeed .. "kts")
				local AltASL = body.FOCore.Position.Y
				local stringAltitude = tostring(math.floor(AltASL))
				MasterPanel.CenterPanel.AltitudeASL.TextLabel.Text = (stringAltitude .. "ft ASL")
				local altRay = Ray.new(body.FOCore.Position, Vector3.new(0,-500,0))
				local rayParams = RaycastParams.new()
				rayParams.FilterDescendantsInstances = planeParts
				rayParams.FilterType = Enum.RaycastFilterType.Blacklist
				local hit = workspace:Raycast(body.FOCore.Position,Vector3.new(0,-1000,0),rayParams)
				if hit then
					local dist = (math.floor((body.FOCore.Position - hit.Position).Magnitude))
					local distString = tostring(dist)
					MasterPanel.CenterPanel.AltitudeAGL.TextLabel.Text = (distString .. "ft AGL")
				else
					MasterPanel.CenterPanel.AltitudeAGL.TextLabel.Text = ("---ft AGL")
				end
			else
				return;
			end
			
		end)
	end;
	["UpdateButtons"] = function()
		local UIParts = script.Parent:GetDescendants()
		for i,v in ipairs(UIParts)do
			
		end
		for i,child in ipairs(FOMain.SystemStatus:GetChildren())do
			if child.Name == "flapN" then
				child.Changed:Connect(function()
					MasterPanel.CenterPanel.AvionicsDis.Flaps.STATUS.Text = (tostring(child.Value))
				end)
			end
			child.Changed:Connect(function()
				
				if child.Name == "spdbrakeStatus" then
					if child.Value == 0 then
						local btn = findObject("spdbrakeDn",UIParts)
						btn.Parent.Indicator.BackgroundColor3 = Color3.fromRGB(0,255,100)
					else
						local btn = findObject("spdbrakeDn",UIParts)
						btn.Parent.Indicator.BackgroundColor3 = Color3.fromRGB(255,0,4)
					end
					if child.Value == 1 then
						local btn = findObject("spdbrakeup",UIParts)
						btn.Parent.Indicator.BackgroundColor3 = Color3.fromRGB(0,255,100)
					else
						local btn = findObject("spdbrakeup",UIParts)
						btn.Parent.Indicator.BackgroundColor3 = Color3.fromRGB(255,0,4)
					end
					if child.Value == 2 then
						local btn = findObject("spdbrakeArmed",UIParts)
						btn.Parent.Indicator.BackgroundColor3 = Color3.fromRGB(0,255,100)
					else
						local btn = findObject("spdbrakeArmed",UIParts)
						btn.Parent.Indicator.BackgroundColor3 = Color3.fromRGB(255,0,4)
					end
					
					
				end
				local currentButton = findObject(child.Name,UIParts) 				
				if currentButton then
					
					if currentButton.Parent:FindFirstChild("Indicator") then
						if child.Value == true then
							currentButton.Parent.Indicator.BackgroundColor3 = Color3.fromRGB(0,255,100)
						elseif child.Value == false then
							currentButton.Parent.Indicator.BackgroundColor3 = Color3.fromRGB(255,0,4)
						elseif child.Value == 2 then
							currentButton.Parent.Indicator.BackgroundColor3 = Color3.fromRGB(0,255,100)
						elseif child.Value == 0 then
							currentButton.Parent.Indicator.BackgroundColor3 = Color3.fromRGB(255,0,4)
						end
					elseif currentButton.Name == "gearToggle" then
						if currentButton.Parent.Parent:FindFirstChild("GearIndicator") then
							local indicator = currentButton.Parent
							if FOMain.SystemStatus.gearToggle.Value == true then
								indicator:TweenPosition(UDim2.new(indicator.Position.X.Scale,indicator.Position.X.Offset,1,indicator.Position.Y.Offset),nil,Enum.EasingStyle.Sine,0.3)
								local colorGoal = {}
								colorGoal.BackgroundColor3 = Color3.new(0,1,0)
								local newTween = tweenService:Create(indicator,TweenInfo.new(0.35),colorGoal)
								newTween:Play()
							else
								indicator:TweenPosition(UDim2.new(indicator.Position.X.Scale,indicator.Position.X.Offset,0.406,indicator.Position.Y.Offset),nil,Enum.EasingStyle.Sine,0.3)
								local colorGoal = {}
								colorGoal.BackgroundColor3 = Color3.new(1,0,0)
								local newTween = tweenService:Create(indicator,TweenInfo.new(0.35),colorGoal)
								newTween:Play()
							end
							
						end
						
					
					else
						if child.Value == true then
							currentButton.BackgroundColor3 = Color3.fromRGB(0,255,100)
						else
							currentButton.BackgroundColor3 = Color3.fromRGB(255,0,4)
						end
					end
				end
				
			end)
		end
		for i,child in ipairs(FOMain.DoorStatus:GetChildren())do
			child.Changed:Connect(function()
				for i,door in ipairs(MasterPanel.DoorPanel.MainFrame:GetDescendants())do
					if door:IsA("StringValue") and door.Value == child.Name then
						if child.Value == true then
							door.Parent.BackgroundColor3 = Color3.fromRGB(0,255,100)
						else
							door.Parent.BackgroundColor3 = Color3.fromRGB(255,0,4)
						end
					end
				end
			end)
		end
	end;
	
	["UpdateButtonsDynamic"] = function()
		local UIParts = script.Parent:GetDescendants()
	
		for i,child in pairs(FOMain.SystemStatus:GetDescendants())do
			if child.Name == "flapN" then
				
				MasterPanel.CenterPanel.AvionicsDis.Flaps.STATUS.Text = (tostring(child.Value))
				
			end
			
			
			if child.Name == "spdbrakeStatus" then
				if child.Value == 0 then
					local btn = findObject("spdbrakeDn",UIParts)
					btn.Parent.Indicator.BackgroundColor3 = Color3.fromRGB(0,255,100)
				else
					local btn = findObject("spdbrakeDn",UIParts)
					btn.Parent.Indicator.BackgroundColor3 = Color3.fromRGB(255,0,4)
				end
				if child.Value == 1 then
					local btn = findObject("spdbrakeup",UIParts)
					btn.Parent.Indicator.BackgroundColor3 = Color3.fromRGB(0,255,100)
				else
					local btn = findObject("spdbrakeup",UIParts)
					btn.Parent.Indicator.BackgroundColor3 = Color3.fromRGB(255,0,4)
				end
				if child.Value == 2 then
					local btn = findObject("spdbrakeArmed",UIParts)
					btn.Parent.Indicator.BackgroundColor3 = Color3.fromRGB(0,255,100)
				else
					local btn = findObject("spdbrakeArmed",UIParts)
					btn.Parent.Indicator.BackgroundColor3 = Color3.fromRGB(255,0,4)
				end


				
	
				
			if MasterPanel:FindFirstChild(child.Name,true) then
				local btn = MasterPanel:FindFirstChild(child.Name,true)
				if btn.Parent:FindFirstChild("Indicator") then
					if child.Value == true then
						btn.Parent.Indicator.BackgroundColor3 = Color3.fromRGB(0,255,100)
					elseif child.Value == false then
						btn.Parent.Indicator.BackgroundColor3 = Color3.fromRGB(255,0,4)
					end
						
				elseif btn.Name == "gearToggle" then
					if btn.Parent.Parent:FindFirstChild("GearIndicator",true) then
						if child.Value == true then
							local indicator = btn.Parent.Parent:FindFirstChild("GearIndicator",true) 
							indicator:TweenPosition(UDim2.new(indicator.Position.X.Scale,indicator.Position.X.Offset,1,indicator.Position.Y.Offset),nil,Enum.EasingStyle.Sine,0.3)
							local colorGoal = {}
							colorGoal.BackgroundColor3 = Color3.new(0,1,0)
							local newTween = tweenService:Create(indicator,TweenInfo.new(0.35),colorGoal)
							newTween:Play()
						else
							local indicator = btn.Parent.Parent:FindFirstChild("GearIndicator",true) 
							indicator:TweenPosition(UDim2.new(indicator.Position.X.Scale,indicator.Position.X.Offset,0.406,indicator.Position.Y.Offset),nil,Enum.EasingStyle.Sine,0.3)
							local colorGoal = {}
							colorGoal.BackgroundColor3 = Color3.new(1,0,0)
							local newTween = tweenService:Create(indicator,TweenInfo.new(0.35),colorGoal)
							newTween:Play()
							end
						end
				else
					if child.Value == true then
						btn.BackgroundColor3 = Color3.fromRGB(0,255,100)
					else
						btn.BackgroundColor3 = Color3.fromRGB(255,0,4)
					end
				end
					
				end
				--[[
				if currentButton then
					print("found")
					if currentButton.Parent:FindFirstChild("Indicator") then
						print("a")
						if child.Value == true then
							currentButton.Parent.Indicator.BackgroundColor3 = Color3.fromRGB(0,255,100)
						else
							currentButton.Parent.Indicator.BackgroundColor3 = Color3.fromRGB(255,0,4)
						end
					elseif currentButton.Name == "gearToggle" then
						if currentButton.Parent.Parent:FindFirstChild("GearIndicator") then
							local indicator = currentButton.Parent
							if FOMain.SystemStatus.gearToggle.Value == true then
								indicator:TweenPosition(UDim2.new(indicator.Position.X.Scale,indicator.Position.X.Offset,1,indicator.Position.Y.Offset),nil,Enum.EasingStyle.Sine,0.3)
								local colorGoal = {}
								colorGoal.BackgroundColor3 = Color3.new(0,1,0)
								local newTween = tweenService:Create(indicator,TweenInfo.new(0.35),colorGoal)
								newTween:Play()
							else
								indicator:TweenPosition(UDim2.new(indicator.Position.X.Scale,indicator.Position.X.Offset,0.406,indicator.Position.Y.Offset),nil,Enum.EasingStyle.Sine,0.3)
								local colorGoal = {}
								colorGoal.BackgroundColor3 = Color3.new(1,0,0)
								local newTween = tweenService:Create(indicator,TweenInfo.new(0.35),colorGoal)
								newTween:Play()
							end

						end


					else
						if child.Value == true then
							currentButton.BackgroundColor3 = Color3.fromRGB(0,255,100)
						else
							currentButton.BackgroundColor3 = Color3.fromRGB(255,0,4)
						end
					end
				end

			end
		end
		for i,child in ipairs(FOMain.DoorStatus:GetChildren())do
			for i,door in ipairs(MasterPanel.DoorPanel.MainFrame:GetChildren()) do
				if door:IsA("StringValue") then
					if door.Value == child.Name then
						if child.Value == true then
							door.Parent.BackgroundColor3 = Color3.fromRGB(0,255,100)
						else
							door.Parent.BackgroundColor3 = Color3.fromRGB(255,0,4)
						end
					end
				end
				
			end
		end
		--]]
			end
		end
		
	end;
}

MasterPanel.HideShowPanel.Btn.MouseButton1Down:Connect(function()
	if currentStatus then
		if currentStatus == "UIHidden" then
			currentStatus = GuiFunctions.showUI()
		elseif currentStatus == "UIShown" then
			currentStatus = GuiFunctions.hideUI()
		end
	else
		currentStatus = GuiFunctions.hideUI()
	end
end)


for i,child in ipairs(MasterPanel.CenterPanel:GetDescendants())do
	if child:isA("TextButton") or child:isA("ImageButton") then
		child.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseMovement then
				if entered then
					if entered == false then
						entered = true
						if child.Name == "spdbrakeDn" or "spdbrakeup" or "spdbrakeArmed" then
							if FOMain.SystemStatus.spdbrakeStatus.Value == 0 then
								if child.Name == "spdbrakeDn" then
									child.Parent:FindFirstChild("Indicator").BackgroundColor3 = Color3.fromRGB(100,180,40)
								end
							elseif FOMain.SystemStatus.spdbrakeStatus.Value == 1 then
								if child.Name == "spdbrakeup" then
									child.Parent:FindFirstChild("Indicator").BackgroundColor3 = Color3.fromRGB(100,180,40)
								end
							elseif FOMain.SystemStatus.spdbrakeStatus.Value == 2 then
								if child.Name == "spdbrakeArmed" then
									child.Parent:FindFirstChild("Indicator").BackgroundColor3 = Color3.fromRGB(100,180,40)
								end
							end
							
						
							
						end
						
						if child.Parent:FindFirstChild("Indicator") then
							if FOMain.SystemStatus:FindFirstChild(child.Name) then
							if FOMain.SystemStatus:FindFirstChild(child.Name).Value == false then
								
								child.Parent.Indicator.BackgroundColor3 = Color3.fromRGB(230,50,40)
								elseif FOMain.SystemStatus:FindFirstChild(child.Name).Value == true then
									child.Parent.Indicator.BackgroundColor3 = Color3.fromRGB(100,180,40)
								elseif FOMain.SystemStatus:FindFirstChild(child.Name).Value == 1 then
									child.Parent.Indicator.BackgroundColor3 = Color3.fromRGB(255,255,100)
								elseif FOMain.SystemStatus[child.Name].Value == 2 then
									child.Parent.Indicator.BackgroundColor3 = Color3.fromRGB(100,180,40)
								elseif FOMain.SystemStatus[child.Name].Value == 0 then	
									child.Parent.Indicator.BackgroundColor3 = Color3.fromRGB(230,50,40)	
									
							end
						end end
						MasterPanel.sfx.mouseHover:Play()
					end
				else
					entered = true
					
					if child.Parent:FindFirstChild("Indicator") then
						if FOMain.SystemStatus:FindFirstChild(child.Name) then
						if FOMain.SystemStatus:FindFirstChild(child.Name).Value == false then
							
							child.Parent.Indicator.BackgroundColor3 = Color3.fromRGB(230,50,40)
						elseif FOMain.SystemStatus[child.Name].Value == true then
								child.Parent.Indicator.BackgroundColor3 = Color3.fromRGB(100,180,40)
							elseif FOMain.SystemStatus[child.Name].Value == 1 then
								child.Parent.Indicator.BackgroundColor3 = Color3.fromRGB(255,255,100)
							elseif FOMain.SystemStatus[child.Name].Value == 2 then
								child.Parent.Indicator.BackgroundColor3 = Color3.fromRGB(100,180,40)
							elseif FOMain.SystemStatus[child.Name].Value == 0 then
								child.Parent.Indicator.BackgroundColor3 = Color3.fromRGB(230,50,40)
						end
					end end
					MasterPanel.sfx.mouseHover:Play()
				end
			end
			
		end)
		child.InputEnded:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseMovement then
				entered = false
				if child.Parent:FindFirstChild("Indicator") then
					if FOMain.SystemStatus:FindFirstChild(child.Name) then
					if FOMain.SystemStatus:FindFirstChild(child.Name).Value == false then
						
						child.Parent.Indicator.BackgroundColor3 = Color3.fromRGB(255,0,4)
						elseif  FOMain.SystemStatus:FindFirstChild(child.Name).Value == true then
							child.Parent.Indicator.BackgroundColor3 = Color3.fromRGB(0,255,100)
						elseif FOMain.SystemStatus[child.Name].Value == 1 then
							child.Parent.Indicator.BackgroundColor3 = Color3.fromRGB(255,255,100)
						elseif FOMain.SystemStatus[child.Name].Value == 2 then
							child.Parent.Indicator.BackgroundColor3 = Color3.fromRGB(0,255,100)
						elseif FOMain.SystemStatus[child.Name].Value == 0 then
							child.Parent.Indicator.BackgroundColor3 = Color3.fromRGB(255,0,4)
					end
					end
				end
				
			end
		end)
	end
end

for i,child in ipairs(MasterPanel.SystemPanel:GetDescendants())do
	if child:isA("TextButton") or child:IsA("ImageButton") then
		child.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseMovement then
				if entered then
					if entered == false then
						entered = true
						
						if child.Parent:FindFirstChild("Indicator") then
							if FOMain.SystemStatus:FindFirstChild(child.Name) then
							if FOMain.SystemStatus:FindFirstChild(child.Name).Value == false then
								
								child.Parent.Indicator.BackgroundColor3 = Color3.fromRGB(230,50,40)
							elseif FOMain.SystemStatus[child.Name].Value == true then
									child.Parent.Indicator.BackgroundColor3 = Color3.fromRGB(100,180,40)
								elseif FOMain.SystemStatus[child.Name].Value == 1 then
									child.Parent.Indicator.BackgroundColor3 = Color3.fromRGB(255,255,100)
								elseif FOMain.SystemStatus[child.Name].Value == 2 then
									child.Parent.Indicator.BackgroundColor3 = Color3.fromRGB(100,180,40)
								elseif FOMain.SystemStatus[child.Name].Value == 0 then
									child.Parent.Indicator.BackgroundColor3 = Color3.fromRGB(230,50,40)
									
								
							end
						end end
						MasterPanel.sfx.mouseHover:Play()
					end
				else
					entered = true
					
					if child.Parent:FindFirstChild("Indicator") then
						if FOMain.SystemStatus:FindFirstChild(child.Name) then
						if FOMain.SystemStatus:FindFirstChild(child.Name).Value == false then
							
							child.Parent.Indicator.BackgroundColor3 = Color3.fromRGB(230,50,40)
						elseif FOMain.SystemStatus[child.Name].Value == true then
								child.Parent.Indicator.BackgroundColor3 = Color3.fromRGB(100,180,40)
							elseif FOMain.SystemStatus[child.Name].Value == 1 then
								child.Parent.Indicator.BackgroundColor3 = Color3.fromRGB(255,255,100)
							elseif FOMain.SystemStatus[child.Name].Value == 2 then
								child.Parent.Indicator.BackgroundColor3 = Color3.fromRGB(100,180,40)
							elseif FOMain.SystemStatus[child.Name].Value == 0 then
								child.Parent.Indicator.BackgroundColor3 = Color3.fromRGB(230,50,40)
						end
					end end
					MasterPanel.sfx.mouseHover:Play()
				end
			end
			
		end)
		child.InputEnded:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseMovement then
				entered = false
				if child.Parent:FindFirstChild("Indicator") then
					if FOMain.SystemStatus:FindFirstChild(child.Name)then
						
					
					if FOMain.SystemStatus:FindFirstChild(child.Name).Value == false then
						
						child.Parent.Indicator.BackgroundColor3 = Color3.fromRGB(255,0,4)
					else
						child.Parent.Indicator.BackgroundColor3 = Color3.fromRGB(0,255,100)
							
						end
						end
				end
			end
		end)
	end
end

for i,child in ipairs(MasterPanel.DoorPanel:GetDescendants())do
	if child:isA("TextButton") or child:IsA("ImageButton") then
		child.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseMovement then
				if entered then
					if entered == false then
						entered = true
						
						if child.Parent:FindFirstChild("Indicator") then
							
							if child.Parent.Indicator.active.Value == false then
								
								child.Parent.Indicator.BackgroundColor3 = Color3.fromRGB(230,50,40)
							end
						end
						MasterPanel.sfx.mouseHover:Play()
					end
				else
					entered = true
					
					if child.Parent:FindFirstChild("Indicator") then
						
						if child.Parent.Indicator.active.Value == false then
							
							child.Parent.Indicator.BackgroundColor3 = Color3.fromRGB(230,50,40)
						elseif child.Parent.Indicator.active.Value == true then
							child.Parent.Indicator.BackgroundColor3 = Color3.fromRGB(100,180,40)
						end
					end
					MasterPanel.sfx.mouseHover:Play()
				end
			end
			
		end)
		child.InputEnded:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseMovement then
				entered = false
				if child.Parent:FindFirstChild("Indicator") then
					
					if child.Parent.Indicator.active.Value == false then
						
						child.Parent.Indicator.BackgroundColor3 = Color3.fromRGB(255,0,4)
					else
						child.Parent.Indicator.BackgroundColor3 = Color3.fromRGB(0,255,100)
					end
				end
			end
		end)
	end
end

MasterPanel.CenterPanel.AvionicsDis.Gear.GearIndicator.gearToggle.MouseButton1Down:Connect(function()
	if FOMain.SystemStatus.gearToggle.Value == true then
		local indicator = MasterPanel.CenterPanel.AvionicsDis.Gear.GearIndicator
		indicator:TweenPosition(UDim2.new(indicator.Position.X.Scale,indicator.Position.X.Offset,0.406,indicator.Position.Y.Offset),nil,Enum.EasingStyle.Sine,0.3)
		local colorGoal = {}
		colorGoal.BackgroundColor3 = Color3.new(1,0,0)
		local newTween = tweenService:Create(indicator,TweenInfo.new(0.35),colorGoal)
		newTween:Play()
	else
		local indicator = MasterPanel.CenterPanel.AvionicsDis.Gear.GearIndicator
		indicator:TweenPosition(UDim2.new(indicator.Position.X.Scale,indicator.Position.X.Offset,1,indicator.Position.Y.Offset),nil,Enum.EasingStyle.Sine,0.3)
		local colorGoal = {}
		colorGoal.BackgroundColor3 = Color3.new(0,1,0)
		local newTween = tweenService:Create(indicator,TweenInfo.new(0.35),colorGoal)
		newTween:Play()
	end
end)

MasterPanel.CenterPanel.EngDis.Eng1.Engine1.MouseButton1Down:Connect(function()
	MasterPanel.CenterPanel.EngDis.Eng1.Indicator.BackgroundColor3 = Color3.fromRGB(255,255,100)
end)

MasterPanel.CenterPanel.EngDis.Eng2.Engine2.MouseButton1Down:Connect(function()
	MasterPanel.CenterPanel.EngDis.Eng2.Indicator.BackgroundColor3 = Color3.fromRGB(255,255,100)
end)


GuiFunctions.UpdateStats()
GuiFunctions.UpdateButtonsDynamic()
GuiFunctions.UpdateButtons()

