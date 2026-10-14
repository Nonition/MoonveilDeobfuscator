-- Synthetic fixture for the supported table-dispatch shape, not vendor output.
return ({
cache0 = {},
decode0 = function(self,a,b,k) self.cache0[k]=a-b return self.cache0[k] end,
worker0 = function(self) return function(input)
 local state, flag
 state=self.cache0[1] or self:decode0(17,10,1)
 while true do
  if state < 9 then
   flag=input
   state=flag and 9 or 12
   flag=not flag
  elseif state < 12 then return flag
  else return self.cache0[2] or self:decode0(52,10,2)
  end
 end
end end,
entry0 = function(self,...) return self:worker0()(...) end,
boot0 = function(self,names,entry,...) return self[entry](self,...) end
}):boot0({}, "entry0", ...)
