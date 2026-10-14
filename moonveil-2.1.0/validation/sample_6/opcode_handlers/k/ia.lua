-- Analysis: VM opcode handler, NOT the user program.
function(g, e, j, l, m, d, q)
    local k, o, p, h, f, i, n
    i = 209
    while true do
        if (i >= 209) then
            if (i > 209) then
                h = f[n]
                l[o] = h
                f, h = 53, e[14]
                o = (h - f)
                i = (((k < f) and (i + (- 39))) or (45632 / i))
            else
                h, k, f = e[26], 237, 13
                o, f, i, n = (h - f), m[28], 248, e[16]
            end
        elseif (i <= 171) then
            h, o, f, p, n = nil, nil, q, d, nil
            return o, h, f, n, p
        else
            i, p, n = 171, 51, e[25]
            f = (n - p)
            h = l[f]
            l[o] = h
        end
    end
end
