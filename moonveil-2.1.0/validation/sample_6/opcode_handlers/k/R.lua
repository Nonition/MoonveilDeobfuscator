-- Analysis: VM opcode handler, NOT the user program.
function(g, r, j, l, m, d, q)
    local p, i, k, f, _, h, n, o
    i = 24
    while true do
        if (i > 112) then
            f, n, p, h = q, nil, d, nil
            return o, h, f, n, p
        elseif (i >= 66) then
            if (i <= 66) then
                f, n = r[23], 40
                h = (f - n)
                l[o] = h
                o = nil
                i = (((_ >= n) and 233) or 24)
            else
                h = (f - n)
                l[o] = h
                h, f = r[14], 24
                o = (h - f)
                i = (((k <= f) and (12544 / i)) or (i + (- 46)))
            end
        else
            h, _, f, k = r[26], 49, 25, 115
            i, f, o, n = 112, r[8], (h - f), 57
        end
    end
end
