-- Moonveil_Deobfuscated.lua
-- Reconstructed from obfuscated (7).txt, MoonVeil 2.1.0.
-- Input SHA-256: fb26e52ce09f4faa5625b0c1b0a15a213af6ffd35ba2db5d570cbf08f6d3c172
-- Control flow and per-iteration closure capture are retained.
-- Descriptive identifiers replace names lost during obfuscation.

local check = assert

local function sumCapturedIndicesSecond()
    local callbacks = {}
    for index in ipairs({1, 2, 3, 4, 5}) do
        local capturedIndex = index
        callbacks[#callbacks + 1] = function()
            return capturedIndex
        end
    end

    local total = 0
    for _, callback in pairs(callbacks) do
        total = total + callback()
    end
    return total
end

local function sumCapturedIndicesFirst()
    local callbacks = {}
    for index in ipairs({1, 2, 3, 4, 5}) do
        local capturedIndex = index
        callbacks[#callbacks + 1] = function()
            return capturedIndex
        end
    end

    local total = 0
    for _, callback in pairs(callbacks) do
        total = total + callback()
    end
    return total
end

check(sumCapturedIndicesFirst() == 15)
check(sumCapturedIndicesSecond() == 15)
