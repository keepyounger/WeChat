//
//  UITableViewCell+ForwordFriendsCircle.m
//  autoGetRedEnv
//
//  Created by 李向阳 on 2016/11/7.
//
//

#import "UIView+ForwordFriendsCircle.h"
#import <objc/runtime.h>
#import "UIViewController+RedBag.h"

@implementation UIView (ForwordFriendsCircle)

- (void)xy_setFavItem:(FavoritesItem *)arg1
{
    [self xy_setFavItem:arg1];

    if (arg1.dataList.firstObject.dataType == 15) {
        UIView *view = [self viewWithTag:1001];
        if (!view) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.tag = 1001;
            [button setTitle:@"转发" forState:UIControlStateNormal];
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(xy_forwordToCircle) forControlEvents:UIControlEventTouchUpInside];
            button.frame = CGRectMake([UIScreen mainScreen].bounds.size.width-59, self.bounds.size.height-49, 44, 44);
            button.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
            button.titleLabel.font = [UIFont systemFontOfSize:14];
            [self addSubview:button];
        }
    } else {
        UIView *view = [self viewWithTag:1001];
        [view removeFromSuperview];
    }
    
}

- (void)xy_forwordToCircle
{
    MMFavCellComponent *view = (MMFavCellComponent*)self;
    if (view.favItem.dataList.firstObject.dataType == 15) {
        
        NSString *imagePath = view.favItem.dataList.firstObject.sourceThumbPath;
        NSString *videoPath = view.favItem.dataList.firstObject.sourceDataPath;
        
        UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:image forKey:@"_thumbImage"];
        [dic setObject:image forKey:@"_realThumbImage"];
        
        [dic setObject:videoPath forKey:@"_moviePath"];
        [dic setObject:videoPath forKey:@"_realMoviePath"];
        
        Class class = objc_getClass("SightMomentEditViewController");
        UIViewController *view = [[class alloc] init];
        view.xy_dicInfo = dic;
        view.xy_contenDes = @"";
        
        [[self xy_navigationController] presentViewController:view animated:YES completion:nil];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"非小视频！" message:@"暂不支持自动转发，请手动复制转发" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
}


- (UINavigationController *)xy_navigationController
{
    UINavigationController *nav = nil;
    UIResponder *rp = self;
    while (rp!=nil) {
        if ([rp isKindOfClass:[UINavigationController class]]) {
            nav = (UINavigationController*)rp;
            return nav;
        }
        rp = [rp nextResponder];
    }
    return nil;
}

@end
