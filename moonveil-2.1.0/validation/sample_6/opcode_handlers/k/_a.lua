-- Analysis: VM opcode handler, NOT the user program.
function(g, r, j, l, m, s, v)
    local d, o, u, n, t, p, a, k, _, h, e, i, q
    i = 212
    while true do
        if (i > 193) then
            if (i > 224) then
                t = n[u]
                l[h] = t
                t, n = r[25], 25
                h = (t - n)
                i = (((p <= n) and (488 - i)) or 193)
            elseif (i > 212) then
                n, t = 63, r[26]
                i, n, h, u = 244, o[3], (t - n), o[1]
            else
                q, n, u, h, p = 192, r[14], 58, m[18], 108
                t = (n - u)
                i, o = 224, h[t]
            end
        elseif (i > 99) then
            if (i > 183) then
                n, u = r[30], 57
                u, t = 1, (n - u)
                n = (t - u)
                i = (((q > u) and 13) or 183)
            else
                i, k, a = 55, 1, (s - h)
                u = (a + k)
            end
        elseif (i > 55) then
            i, a = (154 - i), 1
            u = (t - a)
        elseif (i > 13) then
            d, k, a, e, _ = s, true, u, h, v
            return a, k, _, e, d
        else
            u, a = nil, (- 1)
            i = (((n == a) and 183) or 99)
        end
    end
end
