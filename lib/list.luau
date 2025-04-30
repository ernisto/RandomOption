local function pick<T>(arr: { T }, seed: number?): T
	if seed then math.randomseed(seed) end
	return arr[math.random(seed)]
end
local function shuffle<T>(arr: { T }): { T }
	for index, value in arr do
		local index2 = math.random(1, #arr)
		arr[index], arr[index2] = arr[index2], arr[index]
	end
	return arr
end

-- module
return table.freeze {
	shuffle = shuffle,
	pick = pick,
}
