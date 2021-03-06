--region *.lua
--Date
--此文件由[BabeLua]插件自动生成
local UselessCardsNodeLeft = class("UselessCardsNodeLeft", ccui.Layout)
local GameHelper = require("app.modules.game.GameHelper")
local GameDefine = require("app.modules.game.GameDefine")

function UselessCardsNodeLeft:ctor()
--    self:setBackGroundColorType(1)
--    self:setBackGroundColor({r = 97, g = 2, b = 0})
    self:setCascadeColorEnabled(true)
    self:setAnchorPoint(0, 0.5)
    self:setScale(0.8)
    self.cards = {} --{{cardVal = ?, node = ?}, ...}
    self.rawPos = nil
    self.rawPos = cc.p(self:getPosition())
    local spSampleCard = cc.Sprite:create("GameScene/left/mingmah_00.png")
    self.cardSize = spSampleCard:getContentSize()
    self.cardAnpt = spSampleCard:getAnchorPoint()
    self.cardMaskSize = {width = 0, height = 18}
    self.colIntvl = 0
    self.lineIntvl = -3
    self.columns = 9

    local width = self:calcWidth()
    local sz = {width = 0, height = width}
    self.width = sz.width 
    self.height = sz.height
    self:setContentSize(sz)
    
    local spSampleCard = cc.Sprite:create("GameScene/vertical/mingmah_00.png")
    self.gangCardSize = spSampleCard:getContentSize()
    self.gangCardAnpt = spSampleCard:getAnchorPoint()
    self.gangCardMaskSize = {width = 0, height = 25}
    self.gangCardColIntvl = 0
    self.gangCardLineIntvl = 0
    self.gangCardColumns = 9
end

function UselessCardsNodeLeft:addCards(cards)
    for _, cardVal in ipairs(cards) do 
        table.insert(self.cards, {cardVal = cardVal, node = nil})
    end 
    self:layoutCardsAll()
end 

function UselessCardsNodeLeft:addCard(cardVal)
    table.insert(self.cards, {cardVal = cardVal, node = nil})
    self:layoutCard(self.cards[#self.cards], #self.cards)
end 

--function UselessCardsNodeLeft:rmvCard(cardVal)
--    local card = table.delete(self.cards, cardVal, function(ele)
--        return ele.cardVal == cardVal
--    end)
--    if card.node then 
--        card.node:removeFromParent()
--    end 
--    self:refresh()
--end 

function UselessCardsNodeLeft:rmvTheLast(cardVal)
    local card = self.cards[#self.cards]
    assert(card.cardVal == cardVal)
    card.node:removeFromParent()
    self.cards[#self.cards] = nil
end 

function UselessCardsNodeLeft:calcWidth()
    local width = (self.columns - 1) * 
        (self.cardSize.height + self.colIntvl - self.cardMaskSize.height) + 
        self.cardSize.height
    return width
end 

function UselessCardsNodeLeft:calcHeight()
    --TODO pending implementation
end 

function UselessCardsNodeLeft:calculatePos(index)
    local line = math.ceil(index / self.columns)
    local col = index % self.columns
    col = col == 0 and self.columns or col
    local pos = cc.p(0, 0)
    pos.x = (line - 1) * (self.cardSize.width + self.lineIntvl - self.cardMaskSize.width) + 
        self.cardSize.width * self.cardAnpt.x
    pos.y = self.height - (col - 1) * (self.cardSize.height + self.lineIntvl - self.cardMaskSize.height) - 
        self.cardSize.height * (self.cardAnpt.y - 1)
    return pos
end 

function UselessCardsNodeLeft:layoutCard(card, layoutIndex)
    if not card.node then 
        card.node = Helper.getCardSpriteFlatLeft(card.cardVal)
        GameHelper.decorateCardImgWithSpecialMarkFlat(card.node, card.cardVal, GameDefine.DIR_LEFT)
        card.node:addTo(self)
    end 
    card.node:setLocalZOrder(layoutIndex)
    local pos = self:calculatePos(layoutIndex)
    card.node:setPosition(pos)
end 

function UselessCardsNodeLeft:layoutCardsAll()
    for i, card in ipairs(self.cards) do 
        self:layoutCard(card, i)
    end 
end 

function UselessCardsNodeLeft:createOutCardNode(cardVal)
    local node = Helper.getCardSpriteFlatBottom(cardVal)
    GameHelper.decorateCardImgWithSpecialMarkFlat(node, cardVal, GameDefine.DIR_BOTTOM)
    return node
end 

function UselessCardsNodeLeft:createCardNode(cardVal)
    local node = Helper.getCardSpriteFlatLeft(cardVal)
    GameHelper.decorateCardImgWithSpecialMarkFlat(node, cardVal, GameDefine.DIR_LEFT)
    return node
end 

function UselessCardsNodeLeft:refresh()
    for i, card in ipairs(self.cards) do 
        if not card.node then 
            card.node = self:createCardNode(card.cardVal)
            card.node:addTo(self)
        end 
        card.node.priority = i
        card.node:setLocalZOrder(i)
    end 
    local lineIntvl = -17
    if #self.cards > 0 then 
        local cardSize = self.cards[1].node:getContentSize()
        local sz = CCSize(0, cardSize.height * self.lines + (self.lines - 1) * lineIntvl)
        self:setContentSize(sz)
    end 
    WidgetExt.panLayoutHorizontal(self, {
                autoHeight = false, 
                lineIntvl = lineIntvl, 
                columnIntvl = 0, 
                lines = self.lines, 
--                reverseLine = true, 
                needSort = true})
end 

function UselessCardsNodeLeft:getLastCardPosition()
    if #self.cards == 0 then 
        return nil
    end
    local node = self.cards[#self.cards].node
    local pos = cc.p(node:getPosition())
    return cc.p(node:getParent():convertToWorldSpace(pos))
end 

function UselessCardsNodeLeft:getTheNextCardPosition()
    local pos = self:calculatePos(#self.cards + 1)
    return self:convertToWorldSpace(pos)
end 

function UselessCardsNodeLeft:getTheNextCardSize()
    return {
        width = self.cardSize.width,
        height = self.cardSize.height,
    }
end 

return UselessCardsNodeLeft
--endregion
