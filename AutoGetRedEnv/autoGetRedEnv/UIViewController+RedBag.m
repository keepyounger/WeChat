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

        if (self.xy_dicInfo || self.xy_contenDes) {
            
            NSMutableArray *mArray = [NSMutableArray array];
            [self setValue:mArray forKey:@"_arr_MentionContact"];
            
            __weak UIViewController *weakSelf = self;
            [self.xy_dicInfo enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                [weakSelf setValue:obj forKey:key];
            }];
            
            [self xy_viewDidLoad];
            
            UITextView *textView = [self valueForKeyPath:@"_textView"];
            textView.text = self.xy_contenDes;
            
        } else {
            [self xy_viewDidLoad];
        }
        
        return;
    }
    
    if ([self isKindOfClass:NSClassFromString(@"WCNewCommitViewController")]) {
        
        if (self.xy_images || self.xy_contenDes) {
            
            NSMutableArray *array = [NSMutableArray array];
            [self setValue:array forKeyPath:@"_imageSelectorController.arrImages"];
            [self setValue:@1 forKeyPath:@"_imageSelectorController.type"];
            [self setValue:@YES forKey:@"m_isUseMMAsset"];
            [self setValue:@1 forKey:@"_type"];
            
            for (UIImage *image in self.xy_images) {
                Class class = objc_getClass("MMImage");
                MMImage *mm = [[class alloc] initWithImage:image];
                mm.imageFrom = 3;//3 相册 4照相机
                mm.m_processState = 4;
                [mm setValue:@1 forKey:@"_sourceForSNSUploadStat"];
                [array addObject:mm];
            }
            
            [self xy_viewDidLoad];
            
            UITextView *textView = [self valueForKeyPath:@"_textView"];
            textView.text = self.xy_contenDes;
        } else {
            [self xy_viewDidLoad];
        }

        return;
    }

    if ([self isKindOfClass:NSClassFromString(@"NewSettingViewController")]) {
        
        [self xy_viewDidLoad];
        
        UIViewController *vc = (UIViewController*)self;
        UIBarButtonItem *bbi = [[UIBarButtonItem alloc] initWithTitle:@"扩展设置" style:UIBarButtonItemStylePlain target:self action:@selector(xy_showRedSetting)];
        [bbi setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateNormal];
        [bbi setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateHighlighted];
        
        UIBarButtonItem *back = [[UIBarButtonItem alloc] init];
        back.title = @"";
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
    [vc.navigationController pushViewController:[RedSettingViewController defaultController] animated:YES];
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
