-- Input SHA-256: f235e3843beba872fb69bc2fcc1bc66651ebfeba8a37fd58f366dbb04ed12a4c
-- MoonVeil 2.0.26 profile: automatically recovered code.
-- Constants decoded; reachable numeric-dispatch states structurally accounted for.
-- Names/comments lost before obfuscation are not recoverable by this pass.
-- This is not a claim of universal coverage or live-runtime verification.
local __moonveil_recovered = {}

-- Recovered export: A
__moonveil_recovered.A = function(c, g)
    return function()
        local d, b, e, h, f, j
        d, b = g[3].value, g[1].value
        e, j = d, b
        h = j[e]
        f = (not h)
        b[d] = f
        f, d = e, j
        b = d[f]
        if b then
            b, f = g[2].value, c._.Color3
            d, f, h = f.fromRGB, 50, 200
            j = f
            d = d(f, h, j)
            b.BackgroundColor3 = d
        else
            f, b = c._.Color3, g[2].value
            d, f, h = f.fromRGB, 200, 50
            j = h
            d = d(f, h, j)
            b.BackgroundColor3 = d
        end
        return 
    end
end

-- Recovered export: B
__moonveil_recovered.B = function(c, g)
    return function(k, d)
        local _, f, m, h, e, a, b, l
        h = c._.Instance
        h, l = "Frame", h.new
        l = l(h)
        m = c._.UDim2
        a, h, _, e, m = 28, m.new, 0, (- 6), 1
        h = h(m, e, _, a)
        l.Size = h
        h = 1
        l.BackgroundTransparency = h
        l.LayoutOrder = d
        h = g[1].value
        l.Parent = h
        m = c._.Instance
        m, h = "TextLabel", m.new
        h = h(m)
        e = c._.UDim2
        m, _, e, a = e.new, 145, 0, 1
        b = e
        m = m(e, _, a, b)
        h.Size = m
        e = c._.UDim2
        e, m, _ = 0, e.new, 4
        b, a = e, e
        m = m(e, _, a, b)
        h.Position = m
        m = 1
        h.BackgroundTransparency = m
        h.Text = k
        e = c._.Color3
        e, m = 255, e.fromRGB
        _, a = e, e
        m = m(e, _, a)
        h.TextColor3 = m
        m = 13
        h.TextSize = m
        _ = c._.Enum
        e = _.Font
        m = e.LuckiestGuy
        h.Font = m
        e = _.TextXAlignment
        m = e.Left
        h.TextXAlignment = m
        h.Parent = l
        e = c._.Instance
        m, e = e.new, "TextButton"
        m = m(e)
        m = {value = m}
        _ = c._.UDim2
        _, e, a = 0, _.new, 32
        f, b = 24, _
        e = e(_, a, b, f)
        m.value.Size = e
        _ = c._.UDim2
        b, f, a, e, _ = 0, 2, (- 36), _.new, 1
        e = e(_, a, b, f)
        m.value.Position = e
        _ = c._.Color3
        _, e, a = 200, _.fromRGB, 50
        b = a
        e = e(_, a, b)
        m.value.BackgroundColor3 = e
        e = 0
        m.value.BorderSizePixel = e
        e = ""
        m.value.Text = e
        m.value.Parent = l
        _ = c._.Instance
        e, _ = _.new, "UICorner"
        e = e(_)
        a = c._.UDim
        a, b, _ = 0, 4, a.new
        _ = _(a, b)
        e.CornerRadius = _
        e.Parent = m.value
        _ = false
        _ = {value = _}
        f, a = c:I({_, m}), m.value.MouseButton1Click
        a, b = a.Connect, a
        a(b, f)
        b, a = c:J({_}), l
        return a, b
    end
end

-- Recovered export: C
__moonveil_recovered.C = function(c, g)
    return function()
        local a, b, e, d, f, h
        d = g[1].value
        b = (not d)
        g[1].value = b
        b = g[1].value
        if b then
            b, d = g[5].value, false
            b.Visible = d
            b = g[4].value
            b.Visible = d
            f, b = c._.UDim2, g[2].value
            f, d, h = 0, f.new, 200
            e, a = 36, f
            d = d(f, h, a, e)
            b.Size = d
            b, d = g[3].value, "+"
            b.Text = d
        else
            b, d = g[5].value, true
            b.Visible = d
            b = g[4].value
            b.Visible = d
            f, b = c._.UDim2, g[2].value
            h, d, f = 200, f.new, 0
            a, e = f, 220
            d = d(f, h, a, e)
            b.Size = d
            b, d = g[3].value, "-"
            b.Text = d
        end
        return 
    end
end

-- Recovered export: D
__moonveil_recovered.D = function(c, a)
    return function()
        local d, b
        while true do
            b = a[1].value
            b = b()
            if b then
                d, b = c:K({a[3], a[2]}), c._.pcall
                b(d)
                d = c._.task
                b, d = d.wait, 0.5
                b(d)
            else
                d = c._.task
                d, b = 0.5, d.wait
                b(d)
            end
        end
    end
end

-- Recovered export: E
__moonveil_recovered.E = function(c, g)
    return function()
        local m, b, e, k, h, l, _, d, a
        l, k = "EggGame", g[1].value
        d, k = k, k.WaitForChild
        k = k(d, l)
        k, d, l = k.WaitForChild, k, "Requests"
        k = k(d, l)
        k = {value = k}
        while true do
            d, h, l = false, g[3].value, c._.pairs
            l, h, m = l(h)
            l, h, m = c.g(l, h, m)
            e, _ = l(h, m)
            m = e
            if (m == nil) then
    
            else
                while true do
                    if _ then
                        d = true
                        break
                    else
                        e, _ = l(h, m)
                        m = e
                        if (m == nil) then
                            break
                        end
                    end
                end
            end
            if d then
                l, h = c._.pairs, g[3].value
                l, h, m = l(h)
                l, h, m = c.g(l, h, m)
                e, _ = l(h, m)
                m = e
                if (m == nil) then
    
                else
                    while true do
                        e = {value = e}
                        if _ then
                            b, a = c:L({g[4], k, g[2], e}), c._.pcall
                            a(b)
                            b = c._.task
                            a, b = b.wait, 0.2
                            a(b)
                        end
                        e, _ = l(h, m)
                        m = e
                        if (m == nil) then
                            break
                        end
                    end
                end
            end
            h = c._.task
            l, h = h.wait, 1
            l(h)
        end
    end
end

-- Recovered export: F
__moonveil_recovered.F = function(c, a)
    return function()
        local f, b, d
        b, f = a[1].value, "RebirthState"
        b, d = b.FireServer, b
        b(d, f)
        d = c._.task
        b, d = d.wait, 0.3
        b(d)
        b, f = a[1].value, "Rebirth"
        d, b = b, b.FireServer
        b(d, f)
        return 
    end
end

-- Recovered export: G
__moonveil_recovered.G = function(c, g)
    return function()
        local d, e, a, f, b, h
        d, b = c:H({g[1]}), c._.pcall
        b, d = b(d)
        f = b
        if f then
            a, h = d, c._.type
            h = h(a)
            a = "table"
            f = (h == a)
        end
        if f then
            f = d.ok
        end
        if f then
            f = d.count
            if f then
                h, a = d.count, 0
                f = (h > a)
            end
            if f then
                f = d.token
            end
            if f then
                e, f, a = d.token, g[1].value, "SellAll"
                f, h = f.InvokeServer, f
                f(h, a, e)
            end
        end
        return 
    end
end

-- Recovered export: H
__moonveil_recovered.H = function(c, g)
    return function()
        local b, f, e, d
        e, f, b = nil, "QuoteAll", g[1].value
        d, b = b, b.InvokeServer
        b = c.h(b(d, f, e))
        return c.i(b)
    end
end

-- Recovered export: I
__moonveil_recovered.I = function(c, g)
    return function()
        local a, d, b, f, h
        d = g[1].value
        b = (not d)
        g[1].value = b
        b = g[1].value
        if b then
            b, f = g[2].value, c._.Color3
            h, d, f = 200, f.fromRGB, 50
            a = f
            d = d(f, h, a)
            b.BackgroundColor3 = d
        else
            b, f = g[2].value, c._.Color3
            f, d, h = 200, f.fromRGB, 50
            a = h
            d = d(f, h, a)
            b.BackgroundColor3 = d
        end
        return 
    end
end

-- Recovered export: J
__moonveil_recovered.J = function(c, a)
    return function()
        local b
        b = a[1].value
        return b
    end
end

-- Recovered export: K
__moonveil_recovered.K = function(c, g)
    return function()
        local k, l, h, b, d, n, a, f, e, j, m
        d = g[1].value
        k = d.Character
        if k then
    
        else
            d = g[1].value
            k = d.CharacterAdded
            k, d = k.Wait, k
            k = k(d)
        end
        l, m, d, h = k, 3, k.WaitForChild, "HumanoidRootPart"
        d = d(l, h, m)
        m, l = "ActiveTokens", g[2].value
        l, h = l.FindFirstChild, l
        l = l(h, m)
        h = d
        if h then
            h = l
        end
        if h then
            m, h = l, l.GetChildren
            h = h(m)
            m, e = (# h), 0
            if (m > e) then
                n = c._.math
                a, e, n = (# h), n.random, 1
                e = e(n, a)
                e, b, m = nil, "Model", h[e]
                n, a = m.IsA, m
                n = n(a, b)
                if n then
                    n = m.PrimaryPart
                    if n then
                        a = m.PrimaryPart
                        n = a.Position
                    end
                    if n then
    
                    else
                        b, a = m, m.GetPivot
                        a = a(b)
                        n = a.Position
                    end
                    e = n
                else
                    n, b, a = m.IsA, "BasePart", m
                    n = n(a, b)
                    if n then
                        e = m.Position
                    end
                end
                if e then
                    a = c._.CFrame
                    n, b = a.new, c._.Vector3
                    b, a, f = 0, b.new, 3
                    j = b
                    a = a(b, f, j)
                    a = (e + a)
                    n = n(a)
                    d.CFrame = n
                end
            end
        end
        return 
    end
end

-- Recovered export: L
__moonveil_recovered.L = function(p, g)
    return function()
        local n, d, _, s, m, o, q, e, b, c, a, j, h, k, f
        d = g[1].value
        k = d.Character
        if k then
    
        else
            d = g[1].value
            k = d.CharacterAdded
            d, k = k, k.Wait
            k = k(d)
        end
        m, d, s, h = 3, k.WaitForChild, k, "HumanoidRootPart"
        d = d(s, h, m)
        s = (not d)
        if s then
            return 
        else
            s = nil
            s = {value = s}
            h, e = g[3].value, "EggRuntime"
            h, m = h.FindFirstChild, h
            h = h(m, e)
            if h then
                e, m, n = h, h.FindFirstChild, "WildEggs"
                m = m(e, n)
                if m then
                    a, e, n = m, p._.ipairs, m.GetChildren
                    n = p.h(n(a))
                    e, n, a = e(p.i(n))
                    e, n, a = p.g(e, n, a)
                    b, f = e(n, a)
                    a = b
                    if (a == nil) then
    
                    else
                        while true do
                            j, _ = g[4].value, "KrakenGlory Egg"
                            if (j == _) then
                                _ = p._.string
                                o, j = _, _.find
                                o, _ = f.Name, o.lower
                                _ = _(o)
                                o = "krakenglory"
                                j = j(_, o)
                                if j then
                                    s.value = f
                                    break
                                else
                                    b, f = e(n, a)
                                    a = b
                                    if (a == nil) then
                                        break
                                    end
                                end
                            else
                                j, _ = g[4].value, "Seraph Egg"
                                if (j == _) then
                                    _ = p._.string
                                    _, j = f.Name, _.lower
                                    j = j(_)
                                    o = p._.string
                                    _, c, o = o.find, "adminabuseseraph", j
                                    _ = _(o, c)
                                    if _ then
    
                                    else
                                        o = p._.string
                                        c, _, o = "seraph", o.find, j
                                        _ = _(o, c)
                                    end
                                    if _ then
                                        s.value = f
                                        break
                                    else
                                        b, f = e(n, a)
                                        a = b
                                        if (a == nil) then
                                            break
                                        end
                                    end
                                else
                                    _ = p._.string
                                    o, j = _, _.find
                                    o, _ = f.Name, o.lower
                                    _ = _(o)
                                    c = p._.string
                                    o, c = c.lower, g[4].value
                                    o = p.h(o(c))
                                    j = j(_, p.i(o))
                                    if j then
                                        s.value = f
                                        break
                                    else
                                        b, f = e(n, a)
                                        a = b
                                        if (a == nil) then
                                            break
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
            m = (not s.value)
            if m then
                e, n = g[4].value, "KrakenGlory Egg"
                m = (e == n)
                if m then
    
                else
                    e, n = g[4].value, "Seraph Egg"
                    m = (e == n)
                end
            end
            if m then
                m, e = p._.ipairs, g[3].value
                n, e = e, e.GetDescendants
                e = p.h(e(n))
                m, e, n = m(p.i(e))
                m, e, n = p.g(m, e, n)
                a, b = m(e, n)
                n = a
                if (n == nil) then
    
                else
                    while true do
                        f, j = false, b.Parent
                        while true do
                            _ = j
                            if _ then
                                o = g[3].value
                                _ = (j ~= o)
                            end
                            if _ then
                                o, _ = "EggRuntime", j.Name
                                if (_ == o) then
                                    f = true
                                    break
                                else
                                    j = j.Parent
                                end
                            else
                                break
                            end
                        end
                        _ = (not f)
                        if _ then
                            o, _ = "KrakenGlory Egg", g[4].value
                            if (_ == o) then
                                o = p._.string
                                _, c = o.find, o
                                o, c = c.lower, b.Name
                                o = o(c)
                                c = "krakenglory"
                                _ = _(o, c)
                                if _ then
                                    s.value = b
                                    break
                                else
                                    a, b = m(e, n)
                                    n = a
                                    if (n == nil) then
                                        break
                                    end
                                end
                            else
                                o, _ = "Seraph Egg", g[4].value
                                if (_ == o) then
                                    o = p._.string
                                    _, o = o.lower, b.Name
                                    _ = _(o)
                                    c = p._.string
                                    c, q, o = _, "adminabuseseraph", c.find
                                    o = o(c, q)
                                    if o then
    
                                    else
                                        c = p._.string
                                        q, c, o = "seraph", _, c.find
                                        o = o(c, q)
                                    end
                                    if o then
                                        s.value = b
                                        break
                                    else
                                        a, b = m(e, n)
                                        n = a
                                        if (n == nil) then
                                            break
                                        end
                                    end
                                else
                                    a, b = m(e, n)
                                    n = a
                                    if (n == nil) then
                                        break
                                    end
                                end
                            end
                        else
                            a, b = m(e, n)
                            n = a
                            if (n == nil) then
                                break
                            end
                        end
                    end
                end
            end
            if s.value then
                m = nil
                m = {value = m}
                e, n = p._.pcall, p:N({s, m})
                e(n)
                if m.value then
                    b = p._.Vector3
                    f, a, b = 5, b.new, 0
                    j = b
                    a = a(b, f, j)
                    e, n, a = k.PivotTo, k, (m.value + a)
                    e(n, a)
                    n = p._.task
                    e, n = n.wait, 0.5
                    e(n)
                    n, e = g[3].value, p._.ipairs
                    n, a = n.GetDescendants, n
                    n = p.h(n(a))
                    e, n, a = e(p.i(n))
                    e, n, a = p.g(e, n, a)
                    b, f = e(n, a)
                    a = b
                    if (a == nil) then
    
                    else
                        while true do
                            f = {value = f}
                            j, _, o = f.value.IsA, f.value, "ProximityPrompt"
                            j = j(_, o)
                            if j then
                                j = f.value.Parent
                                _ = j
                                if _ then
                                    _, c, o = j.IsA, "BasePart", j
                                    _ = _(o, c)
                                    if _ then
    
                                    else
                                        _, c, o = j.IsA, "Model", j
                                        _ = _(o, c)
                                    end
                                end
                                if _ then
                                    c, _, o = "BasePart", j.IsA, j
                                    _ = _(o, c)
                                    if _ then
                                        _ = j.Position
                                    end
                                    if _ then
    
                                    else
                                        c, o = j, j.GetPivot
                                        o = o(c)
                                        _ = o.Position
                                    end
                                    q = d.Position
                                    c = (q - _)
                                    o, c = c.Magnitude, 15
                                    if (o <= c) then
                                        c, o = p:M({f}), p._.pcall
                                        o(c)
                                        break
                                    else
                                        b, f = e(n, a)
                                        a = b
                                        if (a == nil) then
                                            break
                                        end
                                    end
                                else
                                    b, f = e(n, a)
                                    a = b
                                    if (a == nil) then
                                        break
                                    end
                                end
                            else
                                b, f = e(n, a)
                                a = b
                                if (a == nil) then
                                    break
                                end
                            end
                        end
                    end
                    n = p._.task
                    e, n = n.wait, 0.3
                    e(n)
                    b = p._.CFrame
                    f, b, a, j = 4, -150, b.new, 222
                    a = p.h(a(b, f, j))
                    e, n = k.PivotTo, k
                    e(n, p.i(a))
                    n = p._.task
                    n, e = 1, n.wait
                    e(n)
                    a, e = "StoreEgg", g[2].value
                    e, n = e.FireServer, e
                    e(n, a)
                end
            end
            return 
        end
    end
end

-- Recovered export: M
__moonveil_recovered.M = function(c, g)
    return function()
        local b, d, f
        b = g[1].value
        b, d = b.InputHoldBegin, b
        b(d)
        f = g[1].value
        d, f = f.HoldDuration, 0
        b = (d > f)
        if b then
            d = g[1].value
            b = d.HoldDuration
        end
        if b then
    
        else
            b = 1.5
        end
        f = c._.task
        d, f = f.wait, 0.2
        f = (b + f)
        d(f)
        d = g[1].value
        d, f = d.InputHoldEnd, d
        d(f)
        return 
    end
end

-- Recovered export: N
__moonveil_recovered.N = function(c, a)
    return function()
        local f, b, d
        b, f = a[1].value, "Model"
        b, d = b.IsA, b
        b = b(d, f)
        if b then
            b = a[1].value
            d, b = b, b.GetPivot
            b = b(d)
            a[2].value = b
        else
            f, b = "BasePart", a[1].value
            d, b = b, b.IsA
            b = b(d, f)
            if b then
                d = a[1].value
                b = d.CFrame
                a[2].value = b
            end
        end
        return 
    end
end

-- Recovered export: _
__moonveil_recovered._ = getfenv()

-- Recovered export: g
__moonveil_recovered.g = (function()
    local q, i, s = type, getmetatable, pairs
    return function(u, v, w)
        if (q(u) ~= "function") then
            local p = i(u)
            if ((p ~= nil) and (p.__iter ~= nil)) then
                return p.__iter(u)
            elseif (((p and p.__call) == nil) and (q(u) == "table")) then
                return s(u)
            end
        end
        return u, v, w
    end
end)()

-- Recovered export: h
__moonveil_recovered.h = function(...)
    return {[1] = {...}, [2] = select("#", ...)}
end

-- Recovered export: i
__moonveil_recovered.i = (function()
    local function m(i, j, k)
        if (j > k) then
            return 
        end
        return i[j], m(i, (j + 1), k)
    end
    return function(o)
        return m(o[1], 1, o[2])
    end
end)()

-- Recovered export: k
__moonveil_recovered.k = function(c)
    return function(...)
        local f, b, d
        b = c:l()
        d, f = b, c:m()
        d(f)
        return 
    end
end

-- Recovered export: l
__moonveil_recovered.l = function(p)
    return function(k)
        local n, d, m, j, c, f, q, e, a, h, _, o, l, s, b
        k = {value = k}
        d = p._.isfile
        if d then
            d = p._.readfile
        end
        if d then
            s, d = "GamingSpirit_KeySystem.txt", p._.isfile
            d = d(s)
        end
        if d then
            d, s, h = p._.tonumber, p._.readfile, "GamingSpirit_KeySystem.txt"
            s = p.h(s(h))
            d = d(p.i(s))
            s = d
            if s then
                e = p._.os
                m = e.time
                m = m()
                m, h = 86400, (m - d)
                s = (h < m)
            end
            if s then
                s = k.value
                s()
                return 
            else
                h, d = "CoreGui", p._.game
                d, s = d.GetService, d
                d = d(s, h)
                d = {value = d}
                s, h = p._.pcall, p:p({d})
                s = s(h)
                h = (not s)
                if h then
                    n, m = "Players", p._.game
                    e, m = m, m.GetService
                    m = m(e, n)
                    h, e = m.LocalPlayer, "PlayerGui"
                    h, m = h.WaitForChild, h
                    h = h(m, e)
                    d.value = h
                end
                h = {value = h}
                m, h.value, n = p:r(), p:q(), p._.Instance
                e, a, n = n.new, d.value, "ScreenGui"
                e = e(n, a)
                e = {value = e}
                a = p._.Instance
                a, b, n = "Frame", e.value, a.new
                n = n(a, b)
                b = p._.UDim2
                a, f, b = b.new, 200, 0
                _, j = 160, b
                a = a(b, f, j, _)
                n.Size = a
                b = p._.UDim2
                f, b, a = -100, 0.5, b.new
                _, j = -80, b
                a = a(b, f, j, _)
                n.Position = a
                b = p._.Color3
                a, b = b.fromRGB, 24
                f, j = b, b
                a = a(b, f, j)
                n.BackgroundColor3 = a
                a = true
                n.Active = a
                b = p._.Instance
                f, b, a = n, "UICorner", b.new
                a(b, f)
                b, a = n, m
                a(b)
                b = p._.Instance
                a, f, b = b.new, n, "TextLabel"
                a = a(b, f)
                f = p._.UDim2
                b, f, j = f.new, 1, 0
                o, _ = 35, j
                b = b(f, j, _, o)
                a.Size = b
                b = "Gaming Spirit Key"
                a.Text = b
                f = p._.Color3
                f, b = 1, f.new
                j = f
                _ = j
                b = b(f, j, _)
                a.TextColor3 = b
                b = 1
                a.BackgroundTransparency = b
                j = p._.Enum
                f = j.Font
                b = f.LuckiestGuy
                a.Font = b
                b = 14
                a.TextSize = b
                f = p._.Instance
                f, j, b = "TextBox", n, f.new
                b = b(f, j)
                b = {value = b}
                j = p._.UDim2
                j, _, f = 0, 180, j.new
                o, c = j, 35
                f = f(j, _, o, c)
                b.value.Size = f
                j = p._.UDim2
                _, c, f, j, o = -90, 0, j.new, 0.5, 0.3
                f = f(j, _, o, c)
                b.value.Position = f
                f = "Enter Key..."
                b.value.PlaceholderText = f
                j = p._.Color3
                f, j = j.fromRGB, 45
                _, o = j, j
                f = f(j, _, o)
                b.value.BackgroundColor3 = f
                j = p._.Color3
                j, f = 1, j.new
                _ = j
                o = _
                f = f(j, _, o)
                b.value.TextColor3 = f
                _ = p._.Enum
                j = _.Font
                f = j.LuckiestGuy
                b.value.Font = f
                f = 12
                b.value.TextSize = f
                j = p._.Instance
                _, j, f = b.value, "UICorner", j.new
                f(j, _)
                j = p._.Instance
                f, j, _ = j.new, "TextButton", n
                f = f(j, _)
                _ = p._.UDim2
                _, o, j = 0, 180, _.new
                c, q = _, 35
                j = j(_, o, c, q)
                f.Size = j
                _ = p._.UDim2
                q, j, o, _, c = 0, _.new, -90, 0.5, 0.58
                j = j(_, o, c, q)
                f.Position = j
                j = "Verify"
                f.Text = j
                _ = p._.Color3
                _, j, o = 50, _.fromRGB, 200
                c = _
                j = j(_, o, c)
                f.BackgroundColor3 = j
                _ = p._.Color3
                _, j = 1, _.new
                o, c = _, _
                j = j(_, o, c)
                f.TextColor3 = j
                o = p._.Enum
                _ = o.Font
                j = _.LuckiestGuy
                f.Font = j
                j = 14
                f.TextSize = j
                _ = p._.Instance
                _, o, j = "UICorner", f, _.new
                j(_, o)
                _ = p._.Instance
                j, _, o = _.new, "TextButton", n
                j = j(_, o)
                j = {value = j}
                o = p._.UDim2
                o, _, c = 0, o.new, 180
                l, q = 25, o
                _ = _(o, c, q, l)
                j.value.Size = _
                o = p._.UDim2
                _, q, c, o, l = o.new, 0.83, -90, 0.5, 0
                _ = _(o, c, q, l)
                j.value.Position = _
                _ = "Get Key Link"
                j.value.Text = _
                o = p._.Color3
                _, q, c, o = o.fromRGB, 219, 152, 52
                _ = _(o, c, q)
                j.value.BackgroundColor3 = _
                o = p._.Color3
                o, _ = 1, o.new
                c = o
                q = c
                _ = _(o, c, q)
                j.value.TextColor3 = _
                c = p._.Enum
                o = c.Font
                _ = o.LuckiestGuy
                j.value.Font = _
                _ = 12
                j.value.TextSize = _
                o = p._.Instance
                c, o, _ = j.value, "UICorner", o.new
                _(o, c)
                c, _ = p:o({j}), j.value.MouseButton1Click
                o, _ = _, _.Connect
                _(o, c)
                _, c = f.MouseButton1Click, p:n({b, k, h, e})
                _, o = _.Connect, _
                _(o, c)
                return 
            end
        else
            h, d = "CoreGui", p._.game
            d, s = d.GetService, d
            d = d(s, h)
            d = {value = d}
            s, h = p._.pcall, p:p({d})
            s = s(h)
            h = (not s)
            if h then
                n, m = "Players", p._.game
                e, m = m, m.GetService
                m = m(e, n)
                h, e = m.LocalPlayer, "PlayerGui"
                h, m = h.WaitForChild, h
                h = h(m, e)
                d.value = h
            end
            h = {value = h}
            m, h.value, n = p:r(), p:q(), p._.Instance
            e, a, n = n.new, d.value, "ScreenGui"
            e = e(n, a)
            e = {value = e}
            a = p._.Instance
            a, b, n = "Frame", e.value, a.new
            n = n(a, b)
            b = p._.UDim2
            a, f, b = b.new, 200, 0
            _, j = 160, b
            a = a(b, f, j, _)
            n.Size = a
            b = p._.UDim2
            f, b, a = -100, 0.5, b.new
            _, j = -80, b
            a = a(b, f, j, _)
            n.Position = a
            b = p._.Color3
            a, b = b.fromRGB, 24
            f, j = b, b
            a = a(b, f, j)
            n.BackgroundColor3 = a
            a = true
            n.Active = a
            b = p._.Instance
            f, b, a = n, "UICorner", b.new
            a(b, f)
            b, a = n, m
            a(b)
            b = p._.Instance
            a, f, b = b.new, n, "TextLabel"
            a = a(b, f)
            f = p._.UDim2
            b, f, j = f.new, 1, 0
            o, _ = 35, j
            b = b(f, j, _, o)
            a.Size = b
            b = "Gaming Spirit Key"
            a.Text = b
            f = p._.Color3
            f, b = 1, f.new
            j = f
            _ = j
            b = b(f, j, _)
            a.TextColor3 = b
            b = 1
            a.BackgroundTransparency = b
            j = p._.Enum
            f = j.Font
            b = f.LuckiestGuy
            a.Font = b
            b = 14
            a.TextSize = b
            f = p._.Instance
            f, j, b = "TextBox", n, f.new
            b = b(f, j)
            b = {value = b}
            j = p._.UDim2
            j, _, f = 0, 180, j.new
            o, c = j, 35
            f = f(j, _, o, c)
            b.value.Size = f
            j = p._.UDim2
            _, c, f, j, o = -90, 0, j.new, 0.5, 0.3
            f = f(j, _, o, c)
            b.value.Position = f
            f = "Enter Key..."
            b.value.PlaceholderText = f
            j = p._.Color3
            f, j = j.fromRGB, 45
            _, o = j, j
            f = f(j, _, o)
            b.value.BackgroundColor3 = f
            j = p._.Color3
            j, f = 1, j.new
            _ = j
            o = _
            f = f(j, _, o)
            b.value.TextColor3 = f
            _ = p._.Enum
            j = _.Font
            f = j.LuckiestGuy
            b.value.Font = f
            f = 12
            b.value.TextSize = f
            j = p._.Instance
            _, j, f = b.value, "UICorner", j.new
            f(j, _)
            j = p._.Instance
            f, j, _ = j.new, "TextButton", n
            f = f(j, _)
            _ = p._.UDim2
            _, o, j = 0, 180, _.new
            c, q = _, 35
            j = j(_, o, c, q)
            f.Size = j
            _ = p._.UDim2
            q, j, o, _, c = 0, _.new, -90, 0.5, 0.58
            j = j(_, o, c, q)
            f.Position = j
            j = "Verify"
            f.Text = j
            _ = p._.Color3
            _, j, o = 50, _.fromRGB, 200
            c = _
            j = j(_, o, c)
            f.BackgroundColor3 = j
            _ = p._.Color3
            _, j = 1, _.new
            o, c = _, _
            j = j(_, o, c)
            f.TextColor3 = j
            o = p._.Enum
            _ = o.Font
            j = _.LuckiestGuy
            f.Font = j
            j = 14
            f.TextSize = j
            _ = p._.Instance
            _, o, j = "UICorner", f, _.new
            j(_, o)
            _ = p._.Instance
            j, _, o = _.new, "TextButton", n
            j = j(_, o)
            j = {value = j}
            o = p._.UDim2
            o, _, c = 0, o.new, 180
            l, q = 25, o
            _ = _(o, c, q, l)
            j.value.Size = _
            o = p._.UDim2
            _, q, c, o, l = o.new, 0.83, -90, 0.5, 0
            _ = _(o, c, q, l)
            j.value.Position = _
            _ = "Get Key Link"
            j.value.Text = _
            o = p._.Color3
            _, q, c, o = o.fromRGB, 219, 152, 52
            _ = _(o, c, q)
            j.value.BackgroundColor3 = _
            o = p._.Color3
            o, _ = 1, o.new
            c = o
            q = c
            _ = _(o, c, q)
            j.value.TextColor3 = _
            c = p._.Enum
            o = c.Font
            _ = o.LuckiestGuy
            j.value.Font = _
            _ = 12
            j.value.TextSize = _
            o = p._.Instance
            c, o, _ = j.value, "UICorner", o.new
            _(o, c)
            c, _ = p:o({j}), j.value.MouseButton1Click
            o, _ = _, _.Connect
            _(o, c)
            _, c = f.MouseButton1Click, p:n({b, k, h, e})
            _, o = _.Connect, _
            _(o, c)
            return 
        end
    end
end

-- Recovered export: m
__moonveil_recovered.m = function(L)
    return function()
        local o, A, y, E, c, b, C, m, F, j, w, z, g, N, p, s, u, x, R, f, q, M, P, J, l, _, I, n, t, e, G, h, d, B, a, r, k, H, i, Q
        F, k = "CoreGui", L._.game
        k, d = k.GetService, k
        k = k(d, F)
        u, d = "Players", L._.game
        F, d = d, d.GetService
        d = d(F, u)
        F, I = L._.game, "Workspace"
        F, u = F.GetService, F
        F = F(u, I)
        F = {value = F}
        e, u = "ReplicatedStorage", L._.game
        I, u = u, u.GetService
        u = u(I, e)
        u = {value = u}
        I = d.LocalPlayer
        I = {value = I}
        e, P, n = k.FindFirstChild, "GamingSpiritScriptHub", k
        e = e(n, P)
        if e then
            e = k.GamingSpiritScriptHub
            e, n = e.Destroy, e
            e(n)
        end
        n = L._.Instance
        n, e = "ScreenGui", n.new
        e = e(n)
        n = "GamingSpiritScriptHub"
        e.Name = n
        n = false
        e.ResetOnSpawn = n
        e.Parent = k
        P = L._.Instance
        n, P = P.new, "Frame"
        n = n(P)
        n = {value = n}
        P = "MainFrame"
        n.value.Name = P
        G = L._.UDim2
        G, P, f = 0, G.new, 200
        j, C = G, 220
        P = P(G, f, j, C)
        n.value.Size = P
        G = L._.UDim2
        C, j, P, f, G = -110, 0.4, G.new, -100, 0.5
        P = P(G, f, j, C)
        n.value.Position = P
        G = L._.Color3
        G, P = 24, G.fromRGB
        f, j = G, G
        P = P(G, f, j)
        n.value.BackgroundColor3 = P
        P = 0
        n.value.BorderSizePixel = P
        P = true
        n.value.Active = P
        n.value.Draggable = P
        n.value.Parent = e
        G = L._.Instance
        G, P = "UICorner", G.new
        P = P(G)
        f = L._.UDim
        f, G, j = 0, f.new, 6
        G = G(f, j)
        P.CornerRadius = G
        P.Parent = n.value
        f = L._.Instance
        f, G = "TextLabel", f.new
        G = G(f)
        f = "TitleLabel"
        G.Name = f
        j = L._.UDim2
        f, j, C = j.new, 0, 160
        o, c = j, 18
        f = f(j, C, o, c)
        G.Size = f
        j = L._.UDim2
        f, C, j = j.new, 8, 0
        o, c = j, C
        f = f(j, C, o, c)
        G.Position = f
        f = 1
        G.BackgroundTransparency = f
        f = "RIDE A FISH"
        G.Text = f
        j = L._.Color3
        f, j = j.fromRGB, 255
        C, o = j, j
        f = f(j, C, o)
        G.TextColor3 = f
        f = 13
        G.TextSize = f
        C = L._.Enum
        j = C.Font
        f = j.LuckiestGuy
        G.Font = f
        j = C.TextXAlignment
        f = j.Left
        G.TextXAlignment = f
        G.Parent = n.value
        j = L._.Instance
        f, j = j.new, "TextButton"
        f = f(j)
        f = {value = f}
        j = "MinimizeBtn"
        f.value.Name = j
        C = L._.UDim2
        C, j, o = 0, C.new, 24
        c, q = C, o
        j = j(C, o, c, q)
        f.value.Size = j
        C = L._.UDim2
        q, c, j, o, C = 6, 0, C.new, -28, 1
        j = j(C, o, c, q)
        f.value.Position = j
        C = L._.Color3
        j, C = C.fromRGB, 45
        o = C
        c = o
        j = j(C, o, c)
        f.value.BackgroundColor3 = j
        j = 0
        f.value.BorderSizePixel = j
        j = "-"
        f.value.Text = j
        C = L._.Color3
        C, j = 255, C.fromRGB
        o, c = C, C
        j = j(C, o, c)
        f.value.TextColor3 = j
        j = 14
        f.value.TextSize = j
        o = L._.Enum
        C = o.Font
        j = C.LuckiestGuy
        f.value.Font = j
        f.value.Parent = n.value
        C = L._.Instance
        j, C = C.new, "UICorner"
        j = j(C)
        o = L._.UDim
        o, C, c = 0, o.new, 4
        C = C(o, c)
        j.CornerRadius = C
        j.Parent = f.value
        o = L._.Instance
        o, C = "ScrollingFrame", o.new
        C = C(o)
        C = {value = C}
        o = "ScrollContainer"
        C.value.Name = o
        c = L._.UDim2
        q, c, R, r, o = -10, 1, 0, 172, c.new
        o = o(c, q, R, r)
        C.value.Size = o
        c = L._.UDim2
        c, q, o = 0, 5, c.new
        R, r = c, 34
        o = o(c, q, R, r)
        C.value.Position = o
        o = 1
        C.value.BackgroundTransparency = o
        o = 0
        C.value.BorderSizePixel = o
        o = 4
        C.value.ScrollBarThickness = o
        q = L._.Enum
        c = q.AutomaticSize
        o = c.Y
        C.value.AutomaticCanvasSize = o
        c = L._.UDim2
        c, o = 0, c.new
        q = c
        R, r = q, q
        o = o(c, q, R, r)
        C.value.CanvasSize = o
        C.value.Parent = n.value
        c = L._.Instance
        o, c = c.new, "UIListLayout"
        o = o(c)
        o.Parent = C.value
        R = L._.Enum
        q = R.SortOrder
        c = q.LayoutOrder
        o.SortOrder = c
        q = L._.UDim
        R, q, c = 6, 0, q.new
        c = c(q, R)
        o.Padding = c
        q = L._.Instance
        q, c = "TextLabel", q.new
        c = c(q)
        c = {value = c}
        q = "FooterLabel"
        c.value.Name = q
        R = L._.UDim2
        R, r, q = 1, 0, R.new
        h, l = 24, r
        q = q(R, r, l, h)
        c.value.Size = q
        R = L._.UDim2
        q, R = R.new, 0
        l, h, r = 1, -26, R
        q = q(R, r, l, h)
        c.value.Position = q
        q = 1
        c.value.BackgroundTransparency = q
        q = "YOUTUBE: SPIRITUAL GAMING"
        c.value.Text = q
        R = L._.Color3
        R, q = 255, R.fromRGB
        r = R
        l = r
        q = q(R, r, l)
        c.value.TextColor3 = q
        q = 11
        c.value.TextSize = q
        r = L._.Enum
        R = r.Font
        q = R.LuckiestGuy
        c.value.Font = q
        c.value.Parent = n.value
        R, q = false, L:B({C})
        R = {value = R}
        r, h = f.value.MouseButton1Click, L:C({R, n, f, c, C})
        l, r = r, r.Connect
        r(l, h)
        l = L._.Instance
        l, r = "Frame", l.new
        r = r(l)
        h = L._.UDim2
        h, Q, l, s, J = 1, -6, h.new, 28, 0
        l = l(h, Q, J, s)
        r.Size = l
        l = 1
        r.BackgroundTransparency = l
        r.LayoutOrder = l
        r.Parent = C.value
        h = L._.Instance
        l, h = h.new, "TextLabel"
        l = l(h)
        Q = L._.UDim2
        s, h, J, Q = 1, Q.new, 145, 0
        A = Q
        h = h(Q, J, s, A)
        l.Size = h
        Q = L._.UDim2
        h, Q, J = Q.new, 0, 4
        s = Q
        A = s
        h = h(Q, J, s, A)
        l.Position = h
        h = 1
        l.BackgroundTransparency = h
        h = "AUTO STEAL"
        l.Text = h
        Q = L._.Color3
        Q, h = 255, Q.fromRGB
        J = Q
        s = J
        h = h(Q, J, s)
        l.TextColor3 = h
        h = 13
        l.TextSize = h
        J = L._.Enum
        Q = J.Font
        h = Q.LuckiestGuy
        l.Font = h
        Q = J.TextXAlignment
        h = Q.Left
        l.TextXAlignment = h
        l.Parent = r
        Q = L._.Instance
        Q, h = "TextButton", Q.new
        h = h(Q)
        h = {value = h}
        J = L._.UDim2
        Q, s, J = J.new, 32, 0
        _, A = 24, J
        Q = Q(J, s, A, _)
        h.value.Size = Q
        J = L._.UDim2
        A, Q, _, J, s = 0, J.new, 2, 1, -36
        Q = Q(J, s, A, _)
        h.value.Position = Q
        J = L._.Color3
        Q, J = J.fromRGB, 45
        s, A = J, J
        Q = Q(J, s, A)
        h.value.BackgroundColor3 = Q
        Q = 0
        h.value.BorderSizePixel = Q
        Q = "\226\150\188"
        h.value.Text = Q
        J = L._.Color3
        Q, J = J.fromRGB, 255
        s, A = J, J
        Q = Q(J, s, A)
        h.value.TextColor3 = Q
        Q = 12
        h.value.TextSize = Q
        s = L._.Enum
        J = s.Font
        Q = J.LuckiestGuy
        h.value.Font = Q
        h.value.Parent = r
        J = L._.Instance
        J, Q = "UICorner", J.new
        Q = Q(J)
        s = L._.UDim
        s, A, J = 0, 4, s.new
        J = J(s, A)
        Q.CornerRadius = J
        Q.Parent = h.value
        s = L._.Instance
        J, s = s.new, "Frame"
        J = J(s)
        J = {value = J}
        A = L._.UDim2
        A, _, s = 1, 0, A.new
        E = _
        p = E
        s = s(A, _, E, p)
        J.value.Size = s
        s = 1
        J.value.BackgroundTransparency = s
        s = false
        J.value.Visible = s
        s = 2
        J.value.LayoutOrder = s
        J.value.Parent = C.value
        A = L._.Instance
        s, A = A.new, "UIListLayout"
        s = s(A)
        s = {value = s}
        s.value.Parent = J.value
        E = L._.Enum
        _ = E.SortOrder
        A = _.LayoutOrder
        s.value.SortOrder = A
        _ = L._.UDim
        A, E, _ = _.new, 4, 0
        A = A(_, E)
        s.value.Padding = A
        A, _, E = s.value.GetPropertyChangedSignal, s.value, "AbsoluteContentSize"
        A = A(_, E)
        A, _, E = A.Connect, A, L:x({J, s})
        A(_, E)
        b, _, w, t, x, N, g, i, H, m, p, a, z, E, B, M, y = "Trench Egg", {}, "AzureCrown Egg", "Deep Egg", "Abyss Egg", "AmethystSpiral Egg", "Eternal Egg", "SolarOrbit Egg", "Sovereign Egg", "Celestial Egg", "Coral Egg", "Spikey Egg", "Reef Egg", "Common Egg", "GlacialSpiral Egg", "CoralReef Egg", "Tidal Egg"
        _[1], _[2], _[3], _[4], _[5], _[6], _[7], _[8], _[9], _[10], _[11], _[12], _[13], _[14], _[15], _[16] = E, p, z, y, t, x, b, H, m, g, M, B, N, w, i, a
        z, p, y, E = "KrakenGlory Egg", "Inferno Egg", "Seraph Egg", "Mamba Egg"
        _[17], _[18], _[19], _[20] = E, p, z, y
        A, E = _, {}
        _ = E
        _ = {value = _}
        p, E = A, L._.ipairs
        E, p, z = E(p)
        E, p, z = L.g(E, p, z)
        y, t = E(p, z)
        z = y
        if (z == nil) then
    
        else
            while true do
                t = {value = t}
                x = false
                _.value[t.value] = x
                b = L._.Instance
                x, b = b.new, "Frame"
                x = x(b)
                H = L._.UDim2
                M, H, b, m, g = 22, 1, H.new, -6, 0
                b = b(H, m, g, M)
                x.Size = b
                b = 1
                x.BackgroundTransparency = b
                x.LayoutOrder = y
                x.Parent = J.value
                H = L._.Instance
                H, b = "TextLabel", H.new
                b = b(H)
                m = L._.UDim2
                m, H, M, g = 0, m.new, 1, 130
                B = m
                H = H(m, g, M, B)
                b.Size = H
                m = L._.UDim2
                m, g, H = 0, 10, m.new
                M, B = m, m
                H = H(m, g, M, B)
                b.Position = H
                H = 1
                b.BackgroundTransparency = H
                b.Text = t.value
                m = L._.Color3
                m, H = 255, m.fromRGB
                g, M = m, m
                H = H(m, g, M)
                b.TextColor3 = H
                H = 11
                b.TextSize = H
                g = L._.Enum
                m = g.Font
                H = m.LuckiestGuy
                b.Font = H
                m = g.TextXAlignment
                H = m.Left
                b.TextXAlignment = H
                b.Parent = x
                m = L._.Instance
                H, m = m.new, "TextButton"
                H = H(m)
                H = {value = H}
                g = L._.UDim2
                m, M, g = g.new, 24, 0
                B, N = g, 22
                m = m(g, M, B, N)
                H.value.Size = m
                g = L._.UDim2
                B, g, m, M = 0, 1, g.new, -32
                N = B
                m = m(g, M, B, N)
                H.value.Position = m
                g = L._.Color3
                g, m, M = 200, g.fromRGB, 50
                B = M
                m = m(g, M, B)
                H.value.BackgroundColor3 = m
                m = 0
                H.value.BorderSizePixel = m
                m = ""
                H.value.Text = m
                H.value.Parent = x
                g = L._.Instance
                g, m = "UICorner", g.new
                m = m(g)
                M = L._.UDim
                g, B, M = M.new, 4, 0
                g = g(M, B)
                m.CornerRadius = g
                m.Parent = H.value
                B, g = L:A({_, H, t}), H.value.MouseButton1Click
                g, M = g.Connect, g
                g(M, B)
                y, t = E(p, z)
                z = y
                if (z == nil) then
                    break
                end
            end
        end
        E = false
        E = {value = E}
        p, z = L:y({E, h, J}), h.value.MouseButton1Click
        z, y, t = z.Connect, z, p
        z(y, t)
        y = L._.Instance
        y, z = "TextButton", y.new
        z = z(y)
        t = L._.UDim2
        y, x, t, b = t.new, 145, 0, 1
        H = t
        y = y(t, x, b, H)
        z.Size = y
        t = L._.UDim2
        y, t = t.new, 0
        b, H, x = t, t, t
        y = y(t, x, b, H)
        z.Position = y
        y = 1
        z.BackgroundTransparency = y
        y = ""
        z.Text = y
        z.Parent = r
        y, x = z.MouseButton1Click, p
        y, t = y.Connect, y
        y(t, x)
        t = L._.task
        t, y = L:E({u, F, _, I}), t.spawn
        y(t)
        x, t, y = 3, "COLLECT TOKENS", q
        y, t = y(t, x)
        t = {value = t}
        b = L._.task
        x, b = b.spawn, L:D({t, F, I})
        x(b)
        H, b, x = 4, "AUTO REBIRTH", q
        x, b = x(b, H)
        b = {value = b}
        m = L._.task
        H, m = m.spawn, L:w({u, b})
        H(m)
        m, H, g = "SELL ALL", q, 5
        H, m = H(m, g)
        m = {value = m}
        M = L._.task
        M, g = L:z({u, m}), M.spawn
        g(M)
        return 
    end
end

-- Recovered export: n
__moonveil_recovered.n = function(c, g)
    return function()
        local d, h, b, f, a
        d = g[1].value
        d, b = g[3].value, d.Text
        d = d()
        if (b == d) then
            b = c._.writefile
            if b then
                b, f, a, d = c._.writefile, c._.tostring, c._.os, "GamingSpirit_KeySystem.txt"
                h = a.time
                h = c.h(h())
                f = c.h(f(c.i(h)))
                b(d, c.i(f))
            end
            b = g[4].value
            d, b = b, b.Destroy
            b(d)
            b = g[2].value
            b()
        else
            b, d = g[1].value, ""
            b.Text = d
            d = "WRONG KEY!"
            b.PlaceholderText = d
        end
        return 
    end
end

-- Recovered export: o
__moonveil_recovered.o = function(c, a)
    return function()
        local b, d
        b = c._.setclipboard
        if b then
            b, d = c._.setclipboard, "https://lootdest.org/s?LqaMr3vF"
            b(d)
            b, d = a[1].value, "Link Copied!"
            b.Text = d
        else
            b, d = a[1].value, "Clipboard not supported"
            b.Text = d
        end
        d = c._.task
        d, b = 2, d.wait
        b(d)
        d, b = "Get Key Link", a[1].value
        b.Text = d
        return 
    end
end

-- Recovered export: p
__moonveil_recovered.p = function(c, a)
    return function()
        local d, b
        d = c._.Instance
        b, d = d.new, "ScreenGui"
        b = b(d)
        d = a[1].value
        b.Parent = d
        return 
    end
end

-- Recovered export: q
__moonveil_recovered.q = function(c)
    return function()
        local f, d, a, e, b, h
        d, b = c:s(), c._.pcall
        b, d = b(d)
        f = b
        if f then
            f = d
        end
        if f then
            f, e, a, h = d.gsub, "", "%s+", d
            f = f(h, a, e)
        end
        if f then
    
        else
            f = "GamingSpiritOnTop"
        end
        return f
    end
end

-- Recovered export: r
__moonveil_recovered.r = function(c)
    return function(k)
        local l, e, j, b, _, h, a, d
        k = {value = k}
        h, d = "UserInputService", c._.game
        l, d = d, d.GetService
        d = d(l, h)
        j, e, h, l = nil, nil, nil, nil
        l = {value = l}
        j = {value = j}
        e = {value = e}
        _, b = k.value.InputBegan, c:u({l, k, j, e})
        a, _ = _, _.Connect
        _(a, b)
        _, b = d.InputChanged, c:t({l, e, j, k})
        a, _ = _, _.Connect
        _(a, b)
        return 
    end
end

-- Recovered export: s
__moonveil_recovered.s = function(c)
    return function()
        local f, d, b
        f, b = "https://pastebin.com/raw/3Yk4R5xS", c._.game
        b, d = b.HttpGet, b
        b = c.h(b(d, f))
        return c.i(b)
    end
end

-- Recovered export: t
__moonveil_recovered.t = function(c, g)
    return function(k)
        local l, h, f, d, e, m, n, b, a
        d = g[1].value
        if d then
            e, l = c._.Enum, k.UserInputType
            m = e.UserInputType
            h = m.MouseMovement
            d = (l == h)
            if d then
    
            else
                l, e = k.UserInputType, c._.Enum
                m = e.UserInputType
                h = m.Touch
                d = (l == h)
            end
        end
        if d then
            l, h = k.Position, g[3].value
            d, m, l = (l - h), c._.UDim2, g[4].value
            h, n = m.new, g[2].value
            e = n.X
            b, m = n, e.Scale
            a = b.X
            n, a = a.Offset, d.X
            e, a = (n + a), b.Y
            f, n = b, a.Scale
            b = f.Y
            a, b = b.Offset, d.Y
            a = (a + b)
            h = h(m, e, n, a)
            l.Position = h
        end
        return 
    end
end

-- Recovered export: u
__moonveil_recovered.u = function(c, g)
    return function(b)
        local f, h, e, d, j
        b = {value = b}
        e, f = c._.Enum, b.value.UserInputType
        j = e.UserInputType
        h = j.MouseButton1
        d = (f == h)
        if d then
    
        else
            f, e = b.value.UserInputType, c._.Enum
            j = e.UserInputType
            h = j.Touch
            d = (f == h)
        end
        if d then
            d = true
            d, g[1].value = b.value.Position, d
            f, g[3].value = g[2].value, d
            d = f.Position
            d, h, g[4].value = b.value.Changed, c:v({b, g[1]}), d
            f, d = d, d.Connect
            d(f, h)
        end
        return 
    end
end

-- Recovered export: v
__moonveil_recovered.v = function(c, g)
    return function()
        local f, d, b, h
        d = g[1].value
        h, b = c._.Enum, d.UserInputState
        f = h.UserInputState
        d = f.End
        if (b == d) then
            b = false
            g[2].value = b
        end
        return 
    end
end

-- Recovered export: w
__moonveil_recovered.w = function(c, g)
    return function()
        local b, d, f
        f, b = "EggGame", g[1].value
        b, d = b.WaitForChild, b
        b = b(d, f)
        f, d, b = "Requests", b, b.WaitForChild
        b = b(d, f)
        b = {value = b}
        while true do
            d = g[2].value
            d = d()
            if d then
                d, f = c._.pcall, c:F({b})
                d(f)
                f = c._.task
                d, f = f.wait, 1
                d(f)
            else
                f = c._.task
                d, f = f.wait, 0.5
                d(f)
            end
        end
    end
end

-- Recovered export: x
__moonveil_recovered.x = function(c, g)
    return function()
        local h, _, k, e, f, j, d
        k, f = g[1].value, c._.UDim2
        h, d, f = 0, f.new, 1
        j, _ = h, g[2].value
        e = _.AbsoluteContentSize
        e = e.Y
        d = d(f, h, j, e)
        k.Size = d
        return 
    end
end

-- Recovered export: y
__moonveil_recovered.y = function(c, a)
    return function()
        local d, b
        d = a[1].value
        b = (not d)
        a[1].value, b = b, a[3].value
        d = a[1].value
        b.Visible = d
        b = a[2].value
        if d then
            d = "\226\150\178"
        end
        if d then
    
        else
            d = "\226\150\188"
        end
        b.Text = d
        return 
    end
end

-- Recovered export: z
__moonveil_recovered.z = function(c, g)
    return function()
        local b, d, f
        f, b = "FishSellRemotes", g[1].value
        b, d = b.WaitForChild, b
        b = b(d, f)
        d, f, b = b, "Request", b.WaitForChild
        b = b(d, f)
        b = {value = b}
        while true do
            d = g[2].value
            d = d()
            if d then
                d, f = c._.pcall, c:G({b})
                d(f)
                f = c._.task
                d, f = f.wait, 5
                d(f)
            else
                f = c._.task
                f, d = 0.5, f.wait
                d(f)
            end
        end
    end
end

return (function(a, ...)
    return a:k()(...)
end)(__moonveil_recovered, ...)
