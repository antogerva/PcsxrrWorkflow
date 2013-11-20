

package.path = ";./src/?.lua;/.src/?.lua;./src/controller/?.lua;./dll/?.lua;./?.lua;../lua/?.lua;" ..package.path
package.cpath = ";./src/?.dll;/.src/?.lua;./src/controller/?.lua;./dll/?.dll;./?.dll;../lua/?.dll;" ..package.cpath


local config = require("model.config")
print("testA")

config.doStuff();