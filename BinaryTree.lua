function Node(parent, data)
    return { 
        data = data,
        parent = parent
    }
end

local PT = {
    head = nil,
    left = nil,
    right = nil,
    insertLeft = function(self, data)
        local node = Node(self.head, data)
        if self.left then
            self.left.next = node
            node.prev = self.left
            self.left = node
          else
            self.head = node
            self.left = node
          end
          return node
    end,
    insertRight = function(self, data)
        local node  = Node(self.head, data)
        if self.right then
            self.right.next = node
            node.prev = self.right
            self.right = node
          else
            self.head = node
            self.right = node
          end
          return node
    end,
}

function GetNode(BT, data)
    local temp = BT.head.parent
    local bt = temp
    while bt do
        if bt.left then
            if bt.left.data == data then
                return bt.left
            end
            bt = bt.left.next
        end
        bt = temp
        if bt.right then
            if bt.left.data == data then
                return bt.left
            end
        end
    end
end


PT.__index = PT
setmetatable(PT, {__call=function(self) return setmetatable({},self) end })

return PT