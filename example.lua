class = require( './class' )
-- @class A
local A = class('我是A类')
A.override = { close=false }	-- 不允许close在子类中重写
A.getter = {
	cba = function (t) return string.format("[%s][%s][%s]", tostring(t),tostring(A),'我是动态获取的cba值' ) end
}
function A:ctor()
	print(string.format("[%s][%s][%s]", tostring(self),tostring(A),'ctor' ))
end
function A:aaa()
	print(string.format("[%s][%s][%s]", tostring(self),tostring(A),'我是A独有的函数aaa' ))
end
function A:abc()
	print(string.format("[%s][%s][%s]", tostring(self),tostring(A),'我是ABC都有的函数abc' ))
end
function A:close()
	print(string.format("[%s][%s][%s]", tostring(self),tostring(A),'close' ))
end
-- @class B:A
local B = class('我是B类',A)
-- B.override = { close=true }	-- 允许close在子类中重写
B.getter = {
	cba = function (t) return string.format("[%s][%s][%s]", tostring(t),tostring(B),'我是动态获取的cba值' ) end
}
function B:ctor()
	print(string.format("[%s][%s][%s]", tostring(self),tostring(B),'ctor' ))
end
function B:bbb()
	print(string.format("[%s][%s][%s]", tostring(self),tostring(B),'我是B独有的函数bbb' ))
end
function B:abc()
	print(string.format("[%s][%s][%s]", tostring(self),tostring(B),'我是ABC都有的函数abc' ))
end
function B:close()
	print(string.format("[%s][%s][%s]", tostring(self),tostring(B),'close' ))
end
-- @class C:B
local C = class('我是C类',B)
C.getter = {
	-- cba = function (t) return string.format("[%s][%s][%s]", tostring(t),tostring(C),'我是动态获取的cba值' ) end
}
function C:ctor()
	print(string.format("[%s][%s][%s]", tostring(self),tostring(C),'ctor' ))
end
function C:bbb()
	print(string.format("[%s][%s][%s]", tostring(self),tostring(C),'我是B独有的函数bbb' ))
end
function C:abc()
	print(string.format("[%s][%s][%s]", tostring(self),tostring(C),'我是ABC都有的函数abc' ))
end
function C:close()
	print(string.format("[%s][%s][%s]", tostring(self),tostring(C),'close' ))
end

-- main
local c = C:new()
c:aaa()
c:bbb()
c:abc()
c:close()
print(c.cba)
