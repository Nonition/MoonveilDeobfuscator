-- Analysis: VM opcode handler, NOT the user program.
function(g, e, j, l, m, d, _)
    local i, h, f, n, p, o
    i = 59
    while true do
        if (i > 59) then
            p, n, h, f = d, nil, nil, _
            return o, h, f, n, p
        else
            h = e[7]
            h, i, o = 38, 236, (_ + h)
            o, _ = nil, (o - h)
        end
    end
end
