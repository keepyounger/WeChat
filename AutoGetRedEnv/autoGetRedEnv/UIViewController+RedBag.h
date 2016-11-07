//
//  UIViewController+RedBag.h
//  autoGetRedEnv
//
//  Created by 李向阳 on 2016/11/6.
//
//

#import <UIKit/UIKit.h>

@interface UIViewController (RedBag)

//转发图文
@property (nonatomic, strong) NSArray<UIImage*> *xy_images;
@property (nonatomic, strong) NSString *xy_contenDes;

//转发小视频
@property (nonatomic, strong) NSDictionary *xy_dicInfo;

- (void)xy_viewDidLoad;
- (void)xy_popSelf;
@end

@interface MMImage : NSObject

@property(nonatomic) int imageFrom; // @synthesize imageFrom=_imageFrom;
@property(nonatomic) int mattID; // @synthesize mattID=_mattID;
- (id)initWithImage:(id)arg1;

@end
