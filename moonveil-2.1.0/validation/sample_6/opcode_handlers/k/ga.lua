-- Analysis: VM opcode handler, NOT the user program.
function(g, r, j, l, m, s, q)
    local e, f, o, p, n, i, a, h, _
    i = 89
    while true do
        if (i <= 123) then
            if (i <= 89) then
                if (i <= 29) then
                    p = 3
                    i, f = (7076 / i), (n - p)
                    a, h, p = 46, l[f], r[25]
                else
                    e, _, i, n, f = 69, 224, 29, 32, r[26]
                    h = (f - n)
                    n, o = r[14], l[h]
                end
            else
                p, f, n = s, q, nil
                return o, h, f, n, p
            end
        else
            n = (p - a)
            f = l[n]
            o[h] = f
            o, h = nil, nil
            i = (((_ <= e) and (333 - i)) or 123)
        end
    end
end
