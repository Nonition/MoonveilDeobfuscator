-- Analysis: VM opcode handler, NOT the user program.
function(g, r, j, l, m, s, q)
    local h, o, n, p, a, _, t, i, k, e
    i = 242
    repeat
        if (i >= 98) then
            if (i <= 234) then
                if (i <= 220) then
                    if (i > 98) then
                        k = a[1]
                        i = (((k >= o) and 18) or 234)
                    else
                        n = nil
                        h, t, n = b.g(h, t, n)
                        p, a = h(t, n)
                        n = p
                        i = (((n == nil) and 25) or 220)
                    end
                else
                    p, a = h(t, n)
                    n = p
                    i = (((n == nil) and 25) or (51480 / i))
                end
            else
                i, t, h = 98, 56, r[26]
                o, h, t = (h - t), j, nil
            end
        elseif (i < 18) then
            k = 2
            a[1] = k
            i, k = (i + 223), nil
            j[p] = k
        elseif (i > 18) then
            t, n, h, p, a = nil, q, nil, nil, s
            return h, t, n, p, a
        else
            _, e = a[3], a[1]
            k = _[e]
            a[2] = k
            i, a[3] = 11, a
        end
    until false
end
