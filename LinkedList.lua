
local function Node(data)
    return { data=data } --implied: return { data=data, prev=nil, next=nil }
end

local List = {
    head = nil,
    tail = nil,
    insertHead = function(self, data)
      local node = Node(data)
      if (self.head) then
        self.head.prev = node
        node.next = self.head
        self.head = node
      else
        self.head = node
        self.tail = node
      end
      return node
    end,
    insertTail = function(self, data)
      local node = Node(data)
      if self.tail then
        self.tail.next = node
        node.prev = self.tail
        self.tail = node
      else
        self.head = node
        self.tail = node
      end
      return node
    end,
    insertBefore = function(self,mark,data)
      if (mark) then
        local node = Node(data)
        if (mark == self.head) then
          self.head.next = node
          node.next = self.head
          self.head = node
        else
          mark.prev.next = node
          node.prev = mark.prev
          mark.prev = node
          node.next = mark
        end
        return node
      else
        -- if no mark given, then insertBefore()==insertHead()
        return self:insertHead(data)
      end
    end,
    insertAfter = function(self,mark,data)
      if (mark) then
        local node = Node(data)
        if (mark == self.tail) then
          self.tail.next = node
          node.prev = self.tail
          self.tail = node
        else
          mark.next.prev = node
          node.next = mark.next
          mark.next = node
          node.prev = mark
        end
        return node
      else
        -- if no mark given, then insertAfter()==insertTail()
        return self:insertTail(data)
      end
    end,
    values = function(self)
      local result, node = {}, self.head
      while (node) do result[#result+1], node = node.data, node.next end
      return result
    end,
}

List.__index = List
setmetatable(List, {__call=function(self) return setmetatable({},self) end })


return List