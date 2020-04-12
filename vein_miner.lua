local interesting = {
	"minecraft:golden_ore",
	"minecraft:iron_ore",
	"minecraft:coal_ore",
	"minecraft:lapis_ore",
	"minecraft:diamond_ore",
	"minecraft:redstone_ore",
	"minecraft:emerald_ore",
	"minecraft:nether_quartz_ore",
	"minecraft:oak_log",
	"minecraft:spruce_log",
	"minecraft:birch_log",
	"minecraft:jungle_log",
	"minecraft:acacia_log",
	"minecraft:bark_oak_log"
} -- add your interesting elements in this variable. 
local blocks = {}

local function examine()
	local pos = turtle.getPos()
	pos.d = 0
	for i=1,table.getn(blocks) do
		blocks[i].d = math.sqrt(math.pow(blocks[i].x-pos.x, 2)+math.pow(blocks[i].z-pos.z, 2)+math.pow(blocks[i].y-pos.y, 2))
	end
end

local function addBlock(pos)
	local add = true
	for i=1,table.getn(blocks) do
		if(blocks[i].x == pos.x and blocks[i].y == pos.y and blocks[i].z == pos.z) then
			add = false
		end
	end
	if(add) then
		table.insert(blocks, pos)
		examine()
	end
end

local function isInteresting(name)
	for i, v in pairs(interesting) do
		if(v == name) then
			return true
		end
	end
	return fals
end

local function scan()
	for i=1, 4 do
		local r, d = turtle.inspect()
		if(r and isInteresting(d.name)) then
			if(turtle.getFacing() == 0) then
				p = turtle.getPos()
				p.x = p.x + 1
				addBlock(p)
			elseif(turtle.getFacing() == 1) then
				p = turtle.getPos()
				p.z = p.z +1
				addBlock(p)
			elseif(turtle.getFacing() == 2) then
				p = turtle.getPos()
				p.x = p.x - 1
				addBlock(p)
			elseif(turtle.getFacing() == 3) then
				p = turtle.getPos()
				p.z = p.z - 1
				addBlock(p)
			end
		end
		turtle.turnLeft()
	end
	local r, d = turtle.inspectUp()
	if(r and isInteresting(d.name)) then
		local p = turtle.getPos()
		p.y = p.y + 1
		addBlock(p)
	end
	local r, d = turtle.inspectDown()
	if(r and isInteresting(d.name)) then
		local p = turtle.getPos()
		p.y = p.y - 1
		addBlock(p)
	end
end


function main()
	scan()
	while table.getn(blocks) > 0 do
		local distance = 10000
		local block = 1
		for i=1,table.getn(blocks) do
			if(blocks[i].d < distance) then
				block = i
			end 
		end
		turtle.go(blocks[block].x, blocks[block].y, blocks[block].z)
		table.remove(blocks, block)
		scan()
	end
end

main()
