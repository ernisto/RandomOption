# Random Option

## Installation
To install with wally, insert it above wally.toml [dependecies]
```toml
RandomOption = "ernisto/random-option@0.2.1"
```
Or with pesde, just run in your terminal
```sh
pesde add ernisto/random_option
```

## Usage
```lua
local commonLoots = RandomOption.new():add(1, 'sword', 'pickaxe', 'apple')  -- RandomOption<string>
-- commonLoots = RandomOption.new{ sword = 1, pickaxe = 1, apple = 1 }

local loot = RandomOption.new{
    [commonLoots] = 75,    -- 75/150 --> 50,0%
    [incommonLoots] = 50,  -- 50/150 --> 33,3%
    [rareLoots] = 20,      -- 20/150 --> 13,3%
    [epicLoots] = 4,       --  4/150 -->  2,6%
    [legendaryLoots] = 1,  --  1/150 -->  0,6%
}   -- RandomOption<RandomOption<string>>
local rarityLoot = loot:choice()
local item = rarityLoot:choice()
```