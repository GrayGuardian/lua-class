-- 从类对象中获取值
local getClassValue = function (object,class,key,...)
	local result = nil
	-- 类
	result = rawget(class,key)
	if(result~=nil) then
		return result
	end
	-- getter
	local getter = rawget(class,'getter')
	if(getter~=nil) then
		result = rawget(getter,key)
		if(result~=nil) then
			return result(object)
		end
	end
	return result
end
-- 获得类实例元表
local getObjectMetatable = function (class)
	local metatable = {}
	-- __index
	metatable.__index = class;
	-- __tostring
	metatable.__tostringx = function (t)
		metatable.__tostring = nil
		local str = table.concat({'Class',' ',class.className,' ',tostring(t)})
		metatable.__tostring = metatable.__tostringx
		return str
	end
	metatable.__tostring = metatable.__tostringx
	return metatable
end

-- 获得类元表
local getClassMetatable = function (object,class,...)
	local metatable = {}
	-- __index
	metatable.__index = function(t,k)
		local result = nil
		-- 类
		result = getClassValue(t,class,k)
		if(result~=nil) then
			return result;
		end
		-- 父类
		local t_cls = class
		repeat
			local super = rawget(t_cls,'super')
			if(super~=nil) then
				result = getClassValue(t,super,k)
				if(result~=nil) then
					return result;
				end
			end
			t_cls = super
		until( t_cls == nil or result ~= nil )
		return result
	end
	-- __tostring
	metatable.__tostringx = function (t)
		metatable.__tostring = nil
		local str = table.concat({'Class',' ',class.className})
		metatable.__tostring = metatable.__tostringx
		return str
	end
	metatable.__tostring = metatable.__tostringx

	return metatable
end
-- 创建类实例，执行构造函数
local create = nil
create = function (object,class,...)
	-- 设置元表
	setmetatable(class,getClassMetatable(object,class,...));
	-- 父类继承
	local super = rawget(class,'super')
	if(super~=nil) then
		-- 存在父类 先去处理父类
		create(object,super,...);
	end
	-- 执行构造函数
	local ctor = rawget(class, 'ctor')
	if(ctor~=nil) then
		ctor(object,...);
	end
end
-- 继承不重写函数处理，自动执行父类函数
local override = nil
override = function (object,class,key,...)
	-- 父类继承
	local super = rawget(class,'super')
	if(super~=nil) then
		-- 存在父类 先去处理父类
		override(object,super,key,...)
	end
	-- 执行具体函数
	func = rawget(class,key)
	if(func~=nil) then
		func(object,...)
	end
end

local class = function (className,super)
	local cls = {};
	cls.className = className	-- 类名
	cls.super = super			-- 父类
	cls.getter = {}				-- 动态变量
	cls.override = nil			-- 是否允许自身重写父类函数 [func_name] = true/false 不允许重写则与构造函数一样 所有父类都将执行
	cls.new = function(self,...)
		local o = setmetatable({},getObjectMetatable(self));
		-- 创建类实例
		create(o,self,...);
		-- 继承不重写函数处理
		if(self.override~=nil) then
			for key, bool in pairs( self.override ) do
				local func = self[key]
				if(func~=nil and not bool) then
					o[key] = function (o,...)
						override(o,self,key,...)
					end
				end
			end
		end
		return o
	end

	return cls;
end

return class