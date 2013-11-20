
package.path = ";./src/?.lua;/.src/?.lua;./src/controller/?.lua;./dll/?.lua;./?.lua;../lua/?.lua;" ..package.path
package.cpath = ";./src/?.dll;/.src/?.lua;./src/controller/?.lua;./dll/?.dll;./?.dll;../lua/?.dll;" ..package.cpath

-- light version of the observer pattern
-- one method notify an another method, that's it.

local observer = require("observer");
local tools = require("tools")
local config = require("model.config")
local lfs = require("lfs")



local test ={}
function test.update(param1, param2)
  --print(tools.to_string(param1,true))
  print("now updating")
  --tools.to_string(alice, true);
end


--config.notifyObserver = observer.signal() --add observer

--print(tools.to_string(test,true))
config.notifyObservers:register(test, test.update)

--config.doStuff();
print(lfs.currentdir())

dofile("src/testA.lua")

--model
local alice = {}

--model
function alice:slot1( param )
  alice.test = param;
  tools.to_string(alice, true);
end


function alice:slot2( param )
  --alice.test = param;
  print("ok")
end



local bob = {}

--view
bob.alert = observer.signal() --add observer

--view
bob.alert:register(alice, alice.slot1);
bob.alert:register(alice, alice.slot2);
--
--bob.alert(true); --action perform
--bob.alert:notify(true); --action perform






--alice:slot(2)
--observer.notify(alice)

--bob.alert:notify()

--print(alice.test)

--alice:set(1)
--print(alice.test)

--tools.to_string(alice, true)

--bob.alert:deregister( alice )
--bob.alert( "Hello?" )



