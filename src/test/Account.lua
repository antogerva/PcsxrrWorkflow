
---@module Account

---Create new Account
--@function [parent=#Account] newAccount
--@param #type initialBalance description
function newAccount (initialBalance)
  local self = {
    balance = initialBalance,
    LIM = 10000.00,
  }

  local extra = function ()
    if self.balance > self.LIM then
      return self.balance*0.10
    else
      return 0
    end
  end

  local getBalance = function ()
    return self.balance + self.extra()
  end

  local withdraw = function (v)
    self.balance = self.balance - v
  end


---Create new Account
--@function [parent=#Account] deposit
--@param #type initialBalance description
  local deposit = function (v)
    self.balance = self.balance + v
  end

  return {
    withdraw = withdraw,
    deposit = deposit,
    getBalance = getBalance
  }
end

---
--@function [parent=#Account] privateStaticMethod
--@param #type initialBalance description
local function privateStaticMethod ()
  
end

return {
  newAccount=newAccount
}
--iup.Message("title", "")

