#ifndef LOBBYDATA_SOURCE_H_
#define LOBBYDATA_SOURCE_H_

#include <iostream>
#include "cocos2d.h"
#include "cocos-ext.h"
#include "CocosGUI.h"
#include "Constant.h"

USING_NS_CC;
USING_NS_CC_EXT;
USING_NS_UI;

// ---------------------------------------------------------
class LobbyDataSource : public cocos2d::extension::TableViewDataSource
{
public:
	LobbyDataSource();
	~LobbyDataSource();

	cocos2d::extension::TableViewCell* tableCellAtIndex(TableView* table, ssize_t idx);
	ssize_t numberOfCellsInTableView(TableView* table);
	Size tableCellSizeForIndex(TableView* tableView, ssize_t idx);
};

// ---------------------------------------------------------
class LobbyListDelegate : public TableViewDelegate
{
public:
	LobbyListDelegate(){};
	~LobbyListDelegate(){};

	void tableCellTouched(TableView* table, TableViewCell* cell);
};

// ---------------------------------------------------------
class CustomTableViewCell : public cocos2d::extension::TableViewCell
{
public:
	virtual void draw(cocos2d::Renderer *renderer, const cocos2d::Mat4 &transform, uint32_t flags) override;

	cocos2d::ui::Layout* m_pLayout;
	cocos2d::ui::ImageView* m_bg;
};

#endif // !LOBBYDATA_SOURCE_H_


