local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local Trove = require(ReplicatedStorage.Packages.Trove)

--------------------------------------------------
-- DEPENDENCIES -- 
--------------------------------------------------

local ProfileTemplate = require(ReplicatedStorage.Modules.ProfileTemplate)


local GameAssets = ReplicatedStorage.GameAssets

-- Tower Assets
local TowersFolder = workspace.PlayerTowers
local TowerAssets = GameAssets.TowerAssets
local Elevator = require(TowerAssets.Elevator)
local Lobby = require(TowerAssets.Lobby)

-- Room Assets
local RoomAssets = GameAssets.RoomAssets
local RoomDefinitions = require(RoomAssets.RoomDefinitions)
local RoomModels = RoomAssets.RoomModels
local LobbyModels = RoomAssets.LobbyModels

--------------------------------------------------
-- TYPES -- 
--------------------------------------------------

type Profile = ProfileTemplate.ProfileTemplate
type TowerData = ProfileTemplate.TowerData
type ColumnData = ProfileTemplate.ColumnData
type LobbyData = ProfileTemplate.LobbyData
type ElevatorData = ProfileTemplate.ElevatorData
type SerializedRoom = ProfileTemplate.SerializedRoom

type Lobby = Lobby.Lobby
type Elevator = Elevator.Elevator

--------------------------------------------------
-- MAIN -- 
--------------------------------------------------

local Column = {}
Column.__index = Column

function Column.new(tower, columnIndex: number, columnData: ColumnData, services)
	local self = setmetatable({}, Column)
	self.Services = services
	self.Trove = Trove.new()
	
	self.Tower = tower
	self.ColumnIndex = columnIndex
	self.ColumnData = columnData


	self:_SetupLobby()
	self:_SetupElevator()

	print("[Column] Created column:", self)
	return self
end

function Column:_SetupLobby()
	local lobby: Lobby = Lobby.new(self, self.ColumnData, self.Services)
	if not lobby then warn("[_SetupLobby] Failed to create lobby") return end
	self.Lobby = lobby
end


function Column:_SetupElevator()
	local elevator: Elevator = Elevator.new(self, self.ColumnData, self.Services)
	if not elevator then warn("[_SetupElevator] Failed to create elevator") return end
	self.Elevator = elevator
end

export type Column = typeof(setmetatable({} :: {}, Column))

return Column
