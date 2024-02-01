--// Module
local RandomOption = {}

--// Types
type dropRates<drop = any> = { [drop]: number }

--// Module Functions
function RandomOption.new<drop>(dropRates: dropRates<drop>?)
    
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
        return self
    end
    function self:add(rate: number,...: drop)
        
        for _,value in {...} do
            
            totalRate += rate
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