-- Analysis: VM opcode handler, NOT the user program.
function(g, e, j, l, m, d, _)
    local i, o, h, f, p, n
    i = 240
    while true do
        if (i >= 237) then
            if (i <= 237) then
                f, p, n, h = _, d, nil, nil
                return o, h, f, n, p
            else
                i, f, h = 28, 63, e[26]
                o, f = (h - f), {}
                h = f
            end
        elseif (i > 28) then
            p = 7
            f = (n - p)
            h = l[f]
            l[o] = h
            i, o = (i + 43), nil
        else
            i, l[o] = 194, h
            f, h = 54, e[14]
            o, n = (h - f), e[25]
        end
    end
end
