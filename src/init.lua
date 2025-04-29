--// Module
local RandomOption = {}

--// Types
type dropRates<drop = any> = { [drop]: number }

--// Module Functions
function RandomOption.new<drop>(_dropRates: dropRates<drop>?)
    local dropRates: dropRates<drop> = if _dropRates then table.clone(_dropRates) else {}

    --// Instance
    local linearRates: { { maxRate: number, value: drop } } = {}
    local totalRate = 0
    local self = {}

    --// Methods
    function self:remove(value: drop, rate: number?)
        rate = rate or dropRates[value]
        assert(rate)
        local rightSide = false

        for _, info in linearRates do
            if not rightSide and info.value ~= value then continue end
            rightSide = true
            info.maxRate -= rate
        end
        if rate then
            dropRates[value] -= rate
            totalRate -= rate
        end
        return self
    end
    function self:add(rate: number, ...: drop)
        for _, value in { ... } do
            totalRate += rate
            dropRates[value] = rate + (dropRates[value] or 0)
            table.insert(linearRates, { value = value, maxRate = totalRate })
        end
        return self
    end
    function self:choice(): drop
        assert(self:isAvailable(), `totalRate: {totalRate} must to be > 0`)
        local rate = math.random() * totalRate

        for _, drop in linearRates do
            if rate <= drop.maxRate then return drop.value end
        end
        error('want possible choice')
    end

    function self:getRarestDrops(amount: number)
        local drops = {}

        for _ = 1, amount do
            local lowestRate = math.huge
            local rarestDrop

            for drop, rate in dropRates do
                if table.find(drops, drop) then continue end
                if rate > lowestRate then continue end

                lowestRate = rate
                rarestDrop = drop
            end
            table.insert(drops, rarestDrop)
        end
        return unpack(drops)
    end
    function self:getWithLuck(multiplier: number, ...: drop)
        local buffedRates = table.clone(dropRates)
        for _, drop in { ... } do
            buffedRates[drop] *= multiplier
        end

        return RandomOption.new(buffedRates)
    end

    function self:isAvailable()
        return totalRate > 0
    end
    function self:clone()
        return RandomOption.new(table.clone(dropRates))
    end

    --// Setup
    for value, rate in dropRates do
        self:add(rate, value)
    end

    --// End
    return (self :: any) :: RandomOption<drop>
end
export type RandomOption<drop = any> = {
    add: (any, rate: number, value: drop) -> RandomOption<drop>,
    remove: (any, value: drop, rate: number?) -> RandomOption<drop>,
    choice: (any) -> drop,

    getRarestDrops: (any, amount: number) -> ...drop,
    getWithLuck: (any, multiplier: number, ...drop) -> RandomOption<drop>,

    isAvailable: (any) -> boolean,
    clone: (any) -> RandomOption<drop>,
}

--// End
return RandomOption
