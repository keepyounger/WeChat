//
//  UIViewController+RedBag.m
//  autoGetRedEnv
//
//  Created by 李向阳 on 2016/11/6.
//
//

#import "UIViewController+RedBag.h"
#import "RedSettingViewController.h"
#import <objc/runtime.h>
#import "JRSwizzle.h"

@implementation UIViewController (RedBag)
- (void)xy_viewDidLoad
{
    if ([self isKindOfClass:NSClassFromString(@"SightMomentEditViewController")]) {

        NSMutableArray *mArray = [NSMutableArray array];
        [self setValue:mArray forKey:@"_arr_MentionContact"];
        
        __weak UIViewController *weakSelf = self;
        [self.xy_dicInfo enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            [weakSelf setValue:obj forKey:key];
        }];
        
        [self xy_viewDidLoad];
        
        UITextView *textView = [self valueForKeyPath:@"_textView.textView"];
        textView.text = self.xy_contenDes;
        
        return;
    }
    
    if ([self isKindOfClass:NSClassFromString(@"WCNewCommitViewController")]) {
        NSMutableArray *array = [NSMutableArray array];
        [self setValue:array forKeyPath:@"_imageSelectorController.arrImages"];
        for (UIImage *image in self.xy_images) {
            Class class = objc_getClass("MMImage");
            MMImage *mm = [[class alloc] initWithImage:image];
            mm.imageFrom = 2;
            [array addObject:mm];
        }
        
        [self xy_viewDidLoad];
        
        UITextView *textView = [self valueForKeyPath:@"_textView.textView"];
        textView.text = self.xy_contenDes;
        
        return;
    }

    if ([self isKindOfClass:NSClassFromString(@"NewSettingViewController")]) {
        
        [self xy_viewDidLoad];
        
        UIViewController *vc = (UIViewController*)self;
        UIBarButtonItem *bbi = [[UIBarButtonItem alloc] initWithTitle:@"红包设置" style:UIBarButtonItemStylePlain target:self action:@selector(xy_showRedSetting)];
        [bbi setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateNormal];
        UIBarButtonItem *back = [[UIBarButtonItem alloc] init];
        back.title = @"返回";
        [back setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateNormal];
        vc.navigationItem.backBarButtonItem = back;
        vc.navigationItem.rightBarButtonItem = bbi;
        
        return;
    }
    
    [self xy_viewDidLoad];

}

- (void)xy_popSelf
{
    if (self.xy_dicInfo) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self xy_popSelf];
    }
}

- (void)xy_showRedSetting
{
    UIViewController *vc = (UIViewController*)self;
    [vc.navigationController pushViewController:[RedSettingViewController sharedInstance] animated:YES];
}

- (void)setXy_images:(NSArray<UIImage *> *)xy_images
{
    objc_setAssociatedObject(self, _cmd, xy_images, OBJC_ASSOCIATION_RETAIN);
}

- (NSArray<UIImage *> *)xy_images
{
    return objc_getAssociatedObject(self, @selector(setXy_images:));
}

- (void)setXy_contenDes:(NSString *)xy_contenDes
{
    objc_setAssociatedObject(self, _cmd, xy_contenDes, OBJC_ASSOCIATION_RETAIN);
}

- (NSString *)xy_contenDes
{
    return objc_getAssociatedObject(self, @selector(setXy_contenDes:));
}

- (void)setXy_dicInfo:(NSDictionary *)xy_dicInfo
{
    objc_setAssociatedObject(self, _cmd, xy_dicInfo, OBJC_ASSOCIATION_RETAIN);
}

- (NSDictionary *)xy_dicInfo
{
    return objc_getAssociatedObject(self, @selector(setXy_dicInfo:));
}

@end
