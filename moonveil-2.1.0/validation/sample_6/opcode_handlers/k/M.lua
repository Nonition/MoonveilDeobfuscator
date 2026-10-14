-- Analysis: VM opcode handler, NOT the user program.
function(g, r, j, l, m, d, q)
    local i, a, k, p, o, n, h, f
    i = 22
    while true do
        if (i >= 171) then
            if (i <= 171) then
                n = (p - a)
                a, k, f = r[25], 36, l[n]
                i, p = (i + (- 134)), (a - k)
            else
                n, f, p = nil, q, d
                return o, h, f, n, p
            end
        elseif (i > 22) then
            n = l[p]
            i, h = (6475 / i), (f + n)
            l[o] = h
            o, h = nil, nil
        else
            h, f = r[26], 18
            i, p, a, o = 171, r[14], 56, (h - f)
        end
    end
end
