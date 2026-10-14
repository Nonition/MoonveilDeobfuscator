-- Analysis: VM opcode handler, NOT the user program.
function(p, a, k, m, g, j, _)
    local l, q, i, d, h, r, c, e, o, n
    h = 94
    repeat
        if (h <= 94) then
            if (h >= 73) then
                if (h > 73) then
                    r, l = p[12], 57
                    n, q, r, l = (r - l), nil, a, nil
                    r, l, q = b.g(r, l, q)
                    i, e = r(l, q)
                    q = i
                    h = (((q == nil) and 143) or 73)
                else
                    c = e[2]
                    h = (((c >= n) and (h + 177)) or (h + (- 1)))
                end
            else
                i, e = r(l, q)
                q = i
                h = (((q == nil) and 143) or (h + 1))
            end
        elseif (h > 143) then
            d, o = e[2], e[3]
            c = o[d]
            e[1] = c
            h, e[3] = (h + (- 178)), e
            c = 1
            e[2] = c
            c = nil
            a[i] = c
        else
            l, q = p[24], 1
            i, q, r = 14, p[29], (l - q)
            l = (q - i)
            j[r] = l
            r, l, i, q = nil, g, _, nil
            return r, l, q, i
        end
    until false
end
