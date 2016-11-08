//
//  UINavigationController+xyHook.m
//  autoGetRedEnv
//
//  Created by 李向阳 on 2016/11/8.
//
//

#import "UINavigationController+xyHook.h"
#import "JRSwizzle.h"
#import <objc/runtime.h>

@implementation UINavigationController (xyHook)

//+ (void)load
//{
//    [UINavigationController jr_swizzleMethod:@selector(pushViewController:animated:) withMethod:@selector(xy_pushViewController:animated:) error:nil];
//}
//
//- (void)xy_pushViewController:(UIViewController *)viewController animated:(BOOL)animated
//{
//    [self xy_pushViewController:viewController animated:animated];
//}

@end

@implementation UIViewController (xyHook)

//+ (void)load
//{
//    [UIViewController jr_swizzleMethod:@selector(viewDidAppear:) withMethod:@selector(xy_viewDidAppear:) error:nil];
//}
//
//- (void)xy_viewDidAppear:(BOOL)animated
//{
//    [self xy_viewDidAppear:animated];
//}

@end
