-- Analysis: VM opcode handler, NOT the user program.
function(p, a, k, m, g, j, _)
    local d, i, h, l, o, n
    h = 137
    repeat
        if (h >= 137) then
            l, d = 51, p[12]
            l, n = {}, (d - l)
            d = l
            j[n] = d
            l, d = 23, p[24]
            n, o, i = (d - l), p[23], 6
            h, l = 39, (o - i)
        else
            d = j[l]
            j[n] = d
            n, o, l, d = nil, _, nil, g
            return n, d, l, o
        end
    until false
end
