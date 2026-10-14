-- Analysis: VM opcode handler, NOT the user program.
function(g, r, j, l, m, d, q)
    local f, p, a, n, k, o, i, h
    i = 233
    while true do
        if (i >= 214) then
            if (i <= 214) then
                i, n = (19260 / i), (p - a)
                f, a, k = l[n], r[25], 21
                p = (a - k)
            else
                h, i, f = r[26], 214, 47
                a, p, o = 5, r[14], (h - f)
            end
        elseif (i <= 81) then
            f, p, n = q, d, nil
            return o, h, f, n, p
        else
            n = l[p]
            h = (f == n)
            i, l[o] = (171 - i), h
            o, h = nil, nil
        end
    end
end
