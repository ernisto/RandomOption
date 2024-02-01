--// Module
local RandomOption = {}

--// Types
type dropRates<drop = any> = { [drop]: number }

--// Module Functions
function RandomOption.new<drop>(_dropRates: dropRates<drop>?)
    
    local dropRates = if _dropRates then table.clone(_dropRates) else {}
    
    --// Instance
    local linearRates = {}
    local totalRate = 0
    local self = {}
    
    --// Methods
    function self:remove(value: drop, rate: number?)
        
        local rightSide = false
        
        for index, info in linearRates do
            
            if not rightSide and info.value ~= value then continue end
            rightSide = true
            
            if rate then table.remove(linearRates, index) end
            info.rate -= rate
        end
        dropRates[value] -= rate
        return self
    end
    function self:add(rate: number,...: drop)
        
        for _,value in {...} do
            
            totalRate += rate
            dropRates[value] = rate + (dropRates[value] or 0)
            table.insert(linearRates, { value = value, maxRate = totalRate })
        end
        return self
    end
    function self:choice(): drop
        
        local rate = math.random(1, totalRate)
        
        for _,drop in linearRates do
            
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
    function self:getWithLuck(multiplier: number,...: drop)
        
        local buffedRates = table.clone(dropRates)
        for _,drop in {...} do buffedRates[drop] *= multiplier end
        
        return RandomOption.new(buffedRates)
    end
    
    --// Setup
    for value, rate in pairs(dropRates or {}) do self:add(rate, value) end
    
    --// End
    return (self :: any) :: RandomOption<drop>
end
export type RandomOption<drop = any> = {
    add: (any, rate: number, value: drop) -> RandomOption<drop>,
    remove: (value: drop, rate: number?) -> RandomOption<drop>,
    choice: (any) -> drop,
}

--// End
return RandomOption