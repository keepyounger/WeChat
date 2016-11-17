//
//  RedManager.m
//  autoGetRedEnv
//
//  Created by 李向阳 on 2016/11/8.
//
//

#import "RedManager.h"
#import <UIKit/UIApplication.h>
#import <objc/runtime.h>
#import "JRSwizzle.h"

void injected_function(void);

__attribute((constructor)) void injected_function(){
    [[NSNotificationCenter defaultCenter] addObserver:[RedManager sharedManager]
                                             selector:@selector(appDidFinished)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
}

@interface RedManager ()

@property (nonatomic, strong) NSMutableDictionary *settingInfo;

@end

@implementation RedManager

static RedManager *_manager = nil;

+ (instancetype)sharedManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[RedManager alloc] init];
    });
    return _manager;
}

- (void)saveSetting
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = [paths objectAtIndex:0];
    if (docDir){
        NSString *path = [docDir stringByAppendingPathComponent:@"RedSettings.plist"];
        [self.settingInfo writeToFile:path atomically:YES];
    }
}

- (NSMutableDictionary *)settingInfo
{
    if (!_settingInfo) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *docDir = [paths objectAtIndex:0];
        if (!docDir){
            return nil;
        }
        NSString *path = [docDir stringByAppendingPathComponent:@"RedSettings.plist"];
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithContentsOfFile:path];
        if (!dict) {
            dict = [NSMutableDictionary dictionary];
        }
        _settingInfo = dict;
    }
    return _settingInfo;
}

- (void)appDidFinished
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = objc_getClass("CMessageMgr");
        [class jr_swizzleMethod:@selector(AsyncOnAddMsg:MsgWrap:) withMethod:@selector(xy_AsyncOnAddMsg:MsgWrap:) error:nil];
        [class jr_swizzleMethod:@selector(onRevokeMsg:) withMethod:@selector(xy_onRevokeMsg:) error:nil];
        
        Class class2 = objc_getClass("NewSettingViewController");
        [class2 jr_swizzleMethod:@selector(viewDidLoad) withMethod:@selector(xy_viewDidLoad) error:nil];
        
        Class class3 = objc_getClass("WCOperateFloatView");
        [class3 jr_swizzleMethod:@selector(init) withMethod:@selector(xy_init) error:nil];
        
        //WCNewCommitViewController
        Class class4 = objc_getClass("WCNewCommitViewController");
        [class4 jr_swizzleMethod:@selector(viewDidLoad) withMethod:@selector(xy_viewDidLoad) error:nil];
        
        //SightMomentEditViewController
        Class class5 = objc_getClass("SightMomentEditViewController");
        [class5 jr_swizzleMethod:@selector(viewDidLoad) withMethod:@selector(xy_viewDidLoad) error:nil];
        [class5 jr_swizzleMethod:@selector(popSelf) withMethod:@selector(xy_popSelf) error:nil];
        
        //MMFavCellComponent
        Class class6 = objc_getClass("SightView");
        [class6 jr_swizzleMethod:@selector(didMoveToWindow) withMethod:@selector(xy_didMoveToWindow) error:nil];
        
        [CLLocation jr_swizzleMethod:@selector(coordinate) withMethod:@selector(xy_coordinate) error:nil];
        
        //WCUtil
        class6 = objc_getClass("WCUtil");
        [class6 jr_swizzleClassMethod:@selector(isUseWxpcDownload) withClassMethod:@selector(xy_isUseWxpcDownload) error:nil];
        [class6 jr_swizzleClassMethod:@selector(isUseWxpcUpload) withClassMethod:@selector(xy_isUseWxpcUpload) error:nil];
        
    });
}

- (void)setRedState:(NSString *)redState
{
    self.settingInfo[@"redState"] = redState;
}

- (NSString *)redState
{
    return self.settingInfo[@"redState"];
}

- (void)setSelfState:(NSString *)selfState
{
    self.settingInfo[@"selfState"] = selfState;
}

- (NSString *)selfState
{
    return self.settingInfo[@"selfState"];
}

- (void)setDelayRandomState:(NSString *)delayRandomState
{
    self.settingInfo[@"delayRandomState"] = delayRandomState;
}

- (NSString *)delayRandomState
{
    return self.settingInfo[@"delayRandomState"];
}

- (void)setDelayTime:(NSString *)delayTime
{
    self.settingInfo[@"delayTime"] = delayTime;
}

- (NSString *)delayTime
{
    return self.settingInfo[@"delayTime"];
}

- (void)setRevokeState:(NSString *)revokeState
{
    self.settingInfo[@"revokeState"] = revokeState;
}

- (NSString *)revokeState
{
    return self.settingInfo[@"revokeState"];
}

- (CLLocationCoordinate2D)location
{
    NSArray *array = [self.locationStr componentsSeparatedByString:@","];
    if (array.count>=2) {
        return CLLocationCoordinate2DMake([array[1] doubleValue], [array[0] doubleValue]);
    }
    return CLLocationCoordinate2DMake(0, 0);
}

- (void)setLocationStr:(NSString *)locationStr
{
    self.settingInfo[@"locationStr"] = locationStr;
}

- (NSString *)locationStr
{
    return self.settingInfo[@"locationStr"];
}

- (void)setLocationState:(NSString *)locationState
{
    self.settingInfo[@"locationState"] = locationState;
}

- (NSString *)locationState
{
    return self.settingInfo[@"locationState"];
}

@end
