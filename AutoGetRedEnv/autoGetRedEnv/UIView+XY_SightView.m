//
//  UIView+XY_SightView.m
//  autoGetRedEnv
//
//  Created by 李向阳 on 2016/11/14.
//
//

#import "UIView+XY_SightView.h"
#import <objc/runtime.h>
#import "UIViewController+RedBag.h"

@implementation UIView (XY_SightView)

- (void)xy_didMoveToWindow
{
    [self xy_didMoveToWindow];
    
    if (!self.window || ![self.window isKindOfClass:NSClassFromString(@"iConsoleWindow")]) {
        return;
    }
    
    UIViewController *vc = [self xy_viewController];
    if ([vc isKindOfClass:NSClassFromString(@"SightMomentEditViewController")] || [vc isKindOfClass:NSClassFromString(@"MsgImgFullScreenViewController")] || [vc isKindOfClass:NSClassFromString(@"FavSightFullScreenViewController")]) {
        return;
    }
    
    if (!self.forwordButton) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width-44, self.frame.size.height-44, 44, 44)];
        button.tag = 101;
        button.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(xy_forwordToCircle) forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:@"转发" forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        button.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleTopMargin;
        [self addSubview:button];
    }
    [self bringSubviewToFront:self.forwordButton];
}

- (UIButton *)forwordButton
{
    return [self viewWithTag:101];
}

- (void)xy_forwordToCircle
{
    
    SightView *view = (SightView*)self;
    
    NSString *imagePath = view.thumbImagePath;
    NSString *videoPath = view.videoPath;
    
    UIImageView *imageView = view.superview.subviews[0];
    
    if ([imageView isKindOfClass:[UIImageView class]]) {
        view.thumbImage = imageView.image;
    }
    
    if (view.thumbImage) {
        NSData *data = UIImageJPEGRepresentation(view.thumbImage, 1);
        imagePath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"image.jpg"];
        [data writeToFile:imagePath atomically:YES];
    }
    
    NSFileManager *manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:imagePath] || ![manager fileExistsAtPath:videoPath]) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"小视频错误！" message:@"可能未下载小视频，请下载后重试" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        
        return;
    }
    
    UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:image forKey:@"_thumbImage"];
    [dic setObject:image forKey:@"_realThumbImage"];
    
    [dic setObject:videoPath forKey:@"_moviePath"];
    [dic setObject:videoPath forKey:@"_realMoviePath"];
    
    Class class = objc_getClass("SightMomentEditViewController");
    UIViewController *vc = [[class alloc] init];
    vc.xy_dicInfo = dic;
    vc.xy_contenDes = @"";
    
    [[self xy_viewController] presentViewController:vc animated:YES completion:nil];
}

- (UIViewController *)xy_viewController
{
    UIViewController *vc = nil;
    UIResponder *rp = self;
    while (rp!=nil) {
        if ([rp isKindOfClass:[UIViewController class]]) {
            vc = (UIViewController*)rp;
            return vc;
        }
        rp = [rp nextResponder];
    }
    return nil;
}

@end
