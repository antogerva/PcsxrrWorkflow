


package.cpath = ";./src/?.dll;/.src/?.lua;./src/socket/?.dll;/.src/socket/?.lua;./dll/?.dll;./?.dll;../lua/?.dll;" ..package.cpath


Account = { balance=0,
            withdraw = function (self, v)
                         self.balance = self.balance - v
                       end
          }

function Account:new (o)
	o = o or {}   -- create object if user does not provide one
	setmetatable(o, self)
	self.__index = self
	return o
end
          

function Account:deposit (v)
  self.balance = self.balance + v
end


a = Account:new{}
print(a.balance)
a:deposit(100.00)

print(a.balance)

--iup.Message("title", "")