//
//  UIView+XY_SightView.h
//  autoGetRedEnv
//
//  Created by 李向阳 on 2016/11/14.
//
//

#import <UIKit/UIKit.h>

@interface UIView (XY_SightView)

@property (nonatomic, strong, readonly) UIButton *forwordButton;
- (void)xy_didMoveToWindow;
@end

@interface SightView : UIView
@property(retain, nonatomic) UIImage *thumbImage; // @synthesize thumbImage=_thumbImage;
@property(retain, nonatomic) NSString *videoPath; // @synthesize videoPath=_videoPath;
@property(retain, nonatomic) NSString *thumbImagePath; // @synthesize thumbImagePath=_thumbImagePath;
@end
