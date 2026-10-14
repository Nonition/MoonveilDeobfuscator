-- Analysis: VM opcode handler, NOT the user program.
function(g, e, j, l, m, d, q)
    local o, p, k, i, h, n, f
    i = 62
    while true do
        if (i > 121) then
            f = {}
            i, h = (i + (- 96)), f
            l[o] = h
            h, o = nil, nil
        elseif (i >= 93) then
            if (i > 93) then
                h = f[n]
                l[o] = h
                h, f = e[14], 56
                o = (h - f)
                i = (((k > f) and (310 - i)) or 121)
            else
                n, f, p = nil, q, d
                return o, h, f, n, p
            end
        else
            f, h, i, k = 27, e[26], 121, 214
            o, n, f = (h - f), e[16], m[28]
        end
    end
end
