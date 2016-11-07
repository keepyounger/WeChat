//
//  UITableViewCell+ForwordFriendsCircle.h
//  autoGetRedEnv
//
//  Created by 李向阳 on 2016/11/7.
//
//

#import <UIKit/UIKit.h>

@class FavoritesItem;

@interface UIView (ForwordFriendsCircle)
- (void)xy_setFavItem:(FavoritesItem*)arg1;
@end


@interface FavoritesItemDataField : NSObject

@property(nonatomic) int dataType; // @synthesize dataType=_dataType; 15小视频
@property(retain, nonatomic) NSString *sourceDataPath; // @synthesize sourceDataPath=_sourceDataPath;
@property(retain, nonatomic) NSString *sourceThumbPath; // @synthesize sourceThumbPath=_sourceThumbPath;

@end

@interface FavoritesItem : NSObject
@property(retain, nonatomic) NSArray<FavoritesItemDataField*> *dataList; // @synthesize dataList=_dataList;
@end

@interface MMFavCellComponent : NSObject
@property(retain, nonatomic) FavoritesItem *favItem; // @synthesize favItem=_favItem;
@end
