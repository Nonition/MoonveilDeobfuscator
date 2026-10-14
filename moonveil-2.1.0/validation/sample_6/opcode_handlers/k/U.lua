-- Analysis: VM opcode handler, NOT the user program.
function(g, e, j, l, m, d, _)
    local f, o, h, p, n, i
    i = 195
    while true do
        if (i <= 186) then
            if (i > 124) then
                h = (f - n)
                i, l[o] = (i + (- 62)), h
                o, f, h = nil, _, nil
            else
                p, n = d, nil
                return o, h, f, n, p
            end
        else
            f, h = 52, e[26]
            o, n, i, f = (h - f), 30, 186, e[8]
        end
    end
end
