

package.path = ";./src/?.lua;/.src/?.lua;./src/controller/?.lua;./dll/?.lua;./?.lua;../lua/?.lua;" ..package.path
package.cpath = ";./src/?.dll;/.src/?.lua;./src/controller/?.lua;./dll/?.dll;./?.dll;../lua/?.dll;" ..package.cpath
require "lfs"

geoo=require("geometry")

geoo.newRectangle(1,y,width,height)

account=require("Account");

account.newAccount(initialBalance)

tools=require("tools")

