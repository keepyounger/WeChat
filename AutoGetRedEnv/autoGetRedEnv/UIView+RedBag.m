//
//  UIView+RedBag.m
//  autoGetRedEnv
//
//  Created by 李向阳 on 2016/11/6.
//
//

#import "UIView+RedBag.h"
#import <objc/runtime.h>
#import "UIViewController+RedBag.h"

@class WCUploadMedia;

static UIWindow *window = nil;

@implementation UIView (RedBag)

- (instancetype)xy_init
{
    UIView *view = [self xy_init];
    view.frame = CGRectMake(0, 0, 270, 39);
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"转发" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(xy_transmit) forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(180, 0, 90, 39);
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    [view addSubview:button];
    return view;
}

- (void)xy_transmit
{

    WCOperateFloatView *view = (WCOperateFloatView*)self;
    [view hide];
    
    WCDataItem *item = [self valueForKeyPath:@"m_likeBtn.m_item"];
    WCContentItem *obj = item.contentObj;
    
    if (obj.type!=1 && obj.type!=15) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"非小视频或者图文！" message:@"暂不支持自动转发，请手动复制转发" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    indicator.layer.cornerRadius = 5;
    indicator.layer.masksToBounds = YES;
    indicator.frame = CGRectMake(0, 0, 200, 150);
    [indicator startAnimating];
    indicator.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.75];
    indicator.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2.0, [UIScreen mainScreen].bounds.size.height/2.0);
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 110, 200, 30)];
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:16];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"请稍等，正在转换...";
    [indicator addSubview:label];
    
    [[UIApplication sharedApplication].delegate.window.rootViewController.view addSubview:indicator];
    
    if (obj.type == 1) {//WCNewCommitViewController
        
        NSMutableArray *array = [NSMutableArray array];
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            //http://[::ffff:111.161.111.114]/mmsns/7CdXdIPctJnqvyQpX966DwpXSZTFWq0EvaZBDpkRLQ7VTUyNJIDIrsDVcXGLKIuMDFaicwdOJBpM/0?tp=wxpc&length=2208&width=1242&idx=1&token=WSEN6qDsKwV8A02w3onOGQYfxnkibdqSOkmHhZGNB4DHDxA720PoFWyeL7MQcY5ov6NAWQy0ZzoUD236JSrf0qA
            for (WCMediaItem *item in obj.mediaList) {
//                NSString *url = item.dataUrl.url;
//                NSString *url = [NSString stringWithFormat:@"%@?tp=wxpc&length=2208&width=1242&idx=1&token=%@", item.dataUrl.url, item.dataUrl.token];
//                NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
                //WCImageView
//                Class class = objc_getClass("WCImageView");
//                WCImageView *view = [[class alloc] initWithMediaData:item imageType:1];
//                [array addObject:[view getImage]];
//                
                //
                Class class = objc_getClass("WCImageFullScreenViewContainer");
                WCImageFullScreenViewContainer *view = [[class alloc] init];
                view.m_mediaData = item;
                [view tryDownloadImage];
                while (![[view valueForKey:@"m_isImageReady"] boolValue]) {
                    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate distantFuture]];
                }
                if (view.m_image) {
                    [array addObject:view.m_image];
                }
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [indicator removeFromSuperview];
                
                Class class = objc_getClass("WCNewCommitViewController");
                UIViewController *view = [[class alloc] init];
                view.xy_contenDes = item.contentDesc;
                view.xy_images = array;
                
                UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:view];
                [[self xy_viewController] presentViewController:nav animated:YES completion:nil];
            });
            
        });
        
    } else {
        
        __block NSData *image = nil;
        __block NSData *mp4 = nil;
      
        dispatch_async(dispatch_get_global_queue(0, 0), ^{

            image = [NSData dataWithContentsOfURL:[NSURL URLWithString:obj.mediaList.firstObject.previewUrls.firstObject.url]];
            mp4 = [NSData dataWithContentsOfURL:[NSURL URLWithString:obj.mediaList.firstObject.dataUrl.url]];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [indicator removeFromSuperview];
                
                NSString *imagePath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"image.jpg"];
                NSString *videoPath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"video.mp4"];
                
                [image writeToFile:imagePath atomically:YES];
                [mp4 writeToFile:videoPath atomically:YES];
                
                NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                [dic setObject:[UIImage imageWithData:image] forKey:@"_thumbImage"];
                [dic setObject:[UIImage imageWithData:image] forKey:@"_realThumbImage"];
                
                [dic setObject:videoPath forKey:@"_moviePath"];
                [dic setObject:videoPath forKey:@"_realMoviePath"];
                
                Class class = objc_getClass("SightMomentEditViewController");
                UIViewController *view = [[class alloc] init];
                view.xy_dicInfo = dic;
                view.xy_contenDes = item.contentDesc;
                
                [[self xy_viewController] presentViewController:view animated:YES completion:nil];
                
            });
        });
    
    }

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

//@implementation NSObject (xxxxx)
//
//- (id)xy_initWithMediaData:(id)arg1 imageType:(int)arg2 isGridPreviewImg:(BOOL)arg3
//{
//    id obj = [self xy_initWithMediaData:arg1 imageType:arg2 isGridPreviewImg:arg3];
//    return obj;
//}
//
//- (id)xy_initWithMediaData:(id)arg1 imageType:(int)arg2 precedentImageType:(int)arg3
//{
//    id obj = [self xy_initWithMediaData:arg1 imageType:arg2 precedentImageType:arg3];
//    return obj;
//}
//
//- (id)xy_initWithMediaData:(id)arg1 imageType:(int)arg2
//{
//    id obj = [self xy_initWithMediaData:arg1 imageType:arg2];
//    return obj;
//}
//
//
//@end

//@implementation UIView (xxxxx)
//
//- (void)xy_onDownloadMediaProcessChange:(id)arg1 downloadType:(int)arg2 current:(int)arg3 total:(int)arg4
//{
//    [self xy_onDownloadMediaProcessChange:arg1 downloadType:arg2 current:arg3 total:arg4];
//}
//
//@end
