-- defs
export type weighted_pick<value = any> = {
	accumulated_weights: { { max_weight: number, value: value } },
	weights: { [value]: number },
	total_weight: number,
}
export type weights<value> = {
    [value]: number
}

-- functions
local function pick<value>(weights: weights<value>): value
	local weight = math.random()

	for value, weight in weights do
		
	end
	error('want possible pick')
end

local function multiply<value>(weights: weights<value>, multiplier: number, ...: value): weights<value><value>
	for _, value in { ... } do
		weights[value] *= multiplier
	end
	return weights
end
local function add<value>(weights: weights<value>, weight: number,...: value): weights<value>
	for _, value in { ... } do
		weights[value] += weight
	end
	return weights
end

local function get_rarest_values<value>(self: weighted_pick<value>, amount: number): ...value
	local values = {}

	for _ = 1, amount do
		local lowest_weight = math.huge
		local rarest_value

		for value, weight in self.weights do
			if table.find(values, value) then continue end
			if weight > lowest_weight then continue end

			lowest_weight = weight
			rarest_value = value
		end
		table.insert(values, rarest_value)
	end
	return unpack(values)
end

-- module
return table.freeze {
	by_weight = by_weight,

	pick = pick,
	add = add,

	get_rarest_values = get_rarest_values,
	get_commun_values = get_common_values,

	clone_with_luck = clone_with_luck,
	clone = clone,
}
