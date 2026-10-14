-- Moonveil_Deobfuscated.lua
-- Reconstructed from obfuscated (6).txt, MoonVeil 2.1.0.
-- Input SHA-256: 0e34cd19184467821dbe6a744b7fa1ef71eb6200b19a754d2f0b5061caf0ad76
-- Control flow and per-iteration closure capture are retained.
-- Descriptive identifiers replace names lost during obfuscation.

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

local check = assert
check(sumCapturedIndicesFirst() == 15)
check(sumCapturedIndicesSecond() == 15)
