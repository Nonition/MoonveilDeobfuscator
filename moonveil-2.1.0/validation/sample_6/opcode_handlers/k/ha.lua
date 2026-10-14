-- Analysis: VM opcode handler, NOT the user program.
function(g, r, j, l, m, s, q)
    local i, e, t, h, o, d, u, a, k, _, n
    i = 39
    while true do
        if (i <= 84) then
            if (i >= 39) then
                if (i <= 54) then
                    if (i <= 39) then
                        i, t, h = 54, 21, r[26]
                        o, n, t = (h - t), 15, r[14]
                    else
                        h, a, u = (t - n), 18, r[25]
                        i, u, n = 134, 1, (u - a)
                    end
                else
                    k, _, e, a = q, nil, s, nil
                    return u, a, k, _, e
                end
            elseif (i <= 1) then
                d, i, e, _ = l[o], 248, n, (e - d)
            else
                i, u, a = (i + 142), (s - h), 1
                t = (u + a)
            end
        elseif (i < 166) then
            a, u, t = 34, r[30], (n - u)
            n, u = (u - a), (- 1)
            i = (((t == u) and 24) or 166)
        elseif (i <= 166) then
            d, u, a, e, i, k = 1, m[21], l, (h + t), 1, h
        else
            i = 84
            u(a, k, _, e, d)
            u = nil
        end
    end
end
