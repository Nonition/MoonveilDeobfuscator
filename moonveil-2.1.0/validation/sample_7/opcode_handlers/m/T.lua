-- Analysis: VM opcode handler, NOT the user program.
function(p, a, k, m, g, j, _)
    local n, d, o, i, l, h
    h = 34
    while true do
        if (h > 34) then
            l = (o - i)
            d = j[l]
            j[n] = d
            n, o, d, l = nil, _, g, nil
            return n, d, l, o
        else
            l, d = 15, p[12]
            l, n, o = k[17], (d - l), p[20]
            d = l[o]
            j[n] = d
            d, l = p[24], 6
            n, i, h, o = (d - l), 55, 175, p[23]
        end
    end
end
