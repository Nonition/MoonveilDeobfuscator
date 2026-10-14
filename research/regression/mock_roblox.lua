-- Local, network-free Roblox API test double. Never sends requests to a game.
local sim = {objects={}, services={}, spawned={}, threads={}, log={}, files={}, now=2000000000, key='TEST_KEY', clipboardAvailable=true}
local function record(kind, ...)
    sim.log[#sim.log+1] = {kind, ...}
end
local function signal(owner, name)
    local sig = {owner=owner, name=name, callbacks={}}
    function sig:Connect(fn)
        self.callbacks[#self.callbacks+1]=fn
        return {Disconnect=function() end}
    end
    function sig:Wait() return self.waitValue end
    return sig
end
local nodeMethods={}
local nodeMT={}
nodeMT.__index=function(n,k)
    if nodeMethods[k] then return nodeMethods[k] end
    local props=rawget(n,'props')
    if props[k]~=nil then return props[k] end
    if k=='Changed' or k=='CharacterAdded' or k=='MouseButton1Click' or k=='InputBegan' or k=='InputChanged' then
        local signals=rawget(n,'signals')
        if not signals[k] then signals[k]=signal(n,k) end
        return signals[k]
    end
    for _,ch in ipairs(rawget(n,'children')) do if ch.props.Name==k then return ch end end
    return nil
end
nodeMT.__newindex=function(n,k,v)
    local props=rawget(n,'props')
    if k=='Parent' then
        local old=props.Parent
        if old then
            for i,ch in ipairs(old.children) do if ch==n then table.remove(old.children,i); break end end
        end
        if v then v.children[#v.children+1]=n end
    end
    props[k]=v
end
local function newNode(class,name,parent)
    local n=setmetatable({id=#sim.objects+1,props={ClassName=class,Name=name or class},children={},signals={}},nodeMT)
    sim.objects[#sim.objects+1]=n
    if parent then n.Parent=parent end
    return n
end
function nodeMethods:FindFirstChild(name)
    for _,child in ipairs(self.children) do if child.Name==name then return child end end
    return nil
end
function nodeMethods:WaitForChild(name, timeout)
    record('WaitForChild',self,name,timeout)
    return self:FindFirstChild(name)
end
function nodeMethods:GetChildren()
    local r={}; for _,n in ipairs(self.children) do r[#r+1]=n end; return r
end
function nodeMethods:GetDescendants()
    local r={}
    local function visit(n) for _,ch in ipairs(n.children) do r[#r+1]=ch; visit(ch) end end
    visit(self);return r
end
function nodeMethods:Destroy() self.Parent=nil; self.props.Destroyed=true; record('Destroy',self) end
function nodeMethods:IsA(class)
    return self.ClassName==class or class=='BasePart' and (self.ClassName=='Part' or self.ClassName=='MeshPart')
end
function nodeMethods:GetPivot() return self.props.Pivot or self.props.CFrame end
function nodeMethods:PivotTo(cf)
    self.props.Pivot=cf
    local root=self:FindFirstChild('HumanoidRootPart')
    if root then root.CFrame=cf; root.Position=cf.Position end
    record('PivotTo',self,cf)
end
function nodeMethods:GetPropertyChangedSignal(name)
    local k='property:'..name
    if not self.signals[k] then self.signals[k]=signal(self,k) end
    return self.signals[k]
end
function nodeMethods:FireServer(...) record('FireServer',self,...) end
function nodeMethods:InvokeServer(...)
    record('InvokeServer',self,...)
    if self.props.InvokeError then error(self.props.InvokeError) end
    return self.props.Response
end
function nodeMethods:InputHoldBegin() record('InputHoldBegin',self) end
function nodeMethods:InputHoldEnd() record('InputHoldEnd',self) end

local vectorMT={}
local function vector(x,y,z) return setmetatable({kind='Vector3',X=x or 0,Y=y or 0,Z=z or 0},vectorMT) end
vectorMT.__add=function(a,b) return vector(a.X+b.X,a.Y+b.Y,a.Z+b.Z) end
vectorMT.__sub=function(a,b) return vector(a.X-b.X,a.Y-b.Y,a.Z-b.Z) end
vectorMT.__index=function(v,k) if k=='Magnitude' then return math.sqrt(v.X*v.X+v.Y*v.Y+v.Z*v.Z) end end
local cfMT={}
local function cframe(x,y,z)
    if type(x)=='table' then return setmetatable({kind='CFrame',Position=x},cfMT) end
    return setmetatable({kind='CFrame',Position=vector(x,y,z)},cfMT)
end
cfMT.__add=function(a,b) return cframe(a.Position+b) end
local function udim(s,o) return {kind='UDim',Scale=s,Offset=o} end
local function udim2(xs,xo,ys,yo) return {kind='UDim2',X=udim(xs,xo),Y=udim(ys,yo)} end
local function color(r,g,b) return {kind='Color3',R=r,G=g,B=b} end
local enum=setmetatable({}, {__index=function(t,k)
    local v=setmetatable({}, {__index=function(u,n)local s='Enum.'..k..'.'..n;rawset(u,n,s);return s end})
    rawset(t,k,v);return v
end})
for _,name in ipairs({'CoreGui','Players','Workspace','ReplicatedStorage','UserInputService'}) do sim.services[name]=newNode(name,name) end
sim.player=newNode('Player','LocalPlayer',sim.services.Players)
sim.services.Players.LocalPlayer=sim.player
newNode('PlayerGui','PlayerGui',sim.player)
sim.character=newNode('Model','Character',sim.services.Workspace)
sim.player.Character=sim.character
sim.player.CharacterAdded.waitValue=sim.character
sim.root=newNode('Part','HumanoidRootPart',sim.character)
sim.root.Position=vector(0,0,0);sim.root.CFrame=cframe(0,0,0);sim.character.Pivot=cframe(0,0,0)
sim.eggGame=newNode('Folder','EggGame',sim.services.ReplicatedStorage)
sim.requests=newNode('RemoteEvent','Requests',sim.eggGame)
sim.fishRemotes=newNode('Folder','FishSellRemotes',sim.services.ReplicatedStorage)
sim.fishRequest=newNode('RemoteFunction','Request',sim.fishRemotes)
sim.fishRequest.Response={ok=true,count=2,token='QUOTE_TOKEN'}
sim.tokens=newNode('Folder','ActiveTokens',sim.services.Workspace)
sim.eggRuntime=newNode('Folder','EggRuntime',sim.services.Workspace)
sim.wildEggs=newNode('Folder','WildEggs',sim.eggRuntime)

local env={}
env._G=env
env.assert=assert;env.error=error;env.select=select;env.unpack=unpack;env.table=table;env.string=string;env.bit32=bit32
env.tonumber=tonumber;env.tostring=tostring;env.type=type;env.pairs=pairs;env.ipairs=ipairs;env.next=next
-- Reproducible local PRNG choice, never affects the host RNG.
env.math={random=function(a,b) return a end, floor=math.floor,abs=math.abs}
env.pcall=pcall;env.getmetatable=getmetatable;env.setmetatable=setmetatable
env.os={time=function() return sim.now end}
env.getfenv=function() return env end
env.game={GetService=function(_,name) assert(sim.services[name],name);return sim.services[name] end,
    HttpGet=function(_,url) record('HttpGet',url); if sim.httpError then error('mock HTTP error') end;return sim.key end}
env.Instance={new=function(class,parent) return newNode(class,nil,parent) end}
env.Enum=enum
env.UDim={new=udim}
env.UDim2={new=udim2,fromOffset=function(x,y)return udim2(0,x,0,y)end}
env.Color3={new=color,fromRGB=function(r,g,b)return color(r/255,g/255,b/255)end}
env.Vector3={new=vector};env.CFrame={new=cframe}
env.isfile=function(path) return sim.files[path]~=nil end
env.readfile=function(path) record('readfile',path);return assert(sim.files[path]) end
env.writefile=function(path,contents) record('writefile',path,contents);sim.files[path]=contents end
env.setclipboard=function(contents) record('setclipboard',contents) end
env.task={
    spawn=function(fn,...)
        sim.spawned[#sim.spawned+1]={fn=fn,args={...}}
    end,
    wait=function(seconds)
        record('wait',seconds)
        return coroutine.yield('wait',seconds)
    end
}
function sim.start(fn,...)
    local co=coroutine.create(fn)
    local ok,a,b=coroutine.resume(co,...)
    if not ok then error(a) end
    sim.threads[#sim.threads+1]=co
    return co,a,b
end
function sim.step(co)
    if coroutine.status(co)=='dead' then return 'dead' end
    local ok,a,b=coroutine.resume(co,1)
    if not ok then error(a) end
    return a,b
end
function sim.fire(node,name,...)
    local s=node.signals[name]
    assert(s,'missing signal '..name)
    local threads={}
    for _,fn in ipairs(s.callbacks) do threads[#threads+1]=sim.start(fn,...) end
    return threads
end
function sim.find(name)
    for _,n in ipairs(sim.objects) do if n.Name==name then return n end end
end
function sim.findText(text)
    for _,n in ipairs(sim.objects) do if n.Text==text then return n end end
end
function sim.execute(source)
    local fn,err=loadstring(source,'@test_subject')
    assert(fn,err)
    setfenv(fn,env)
    return sim.start(fn)
end
sim.env=env
sim.newNode=newNode;sim.vector=vector;sim.cframe=cframe;sim.udim2=udim2
return sim
