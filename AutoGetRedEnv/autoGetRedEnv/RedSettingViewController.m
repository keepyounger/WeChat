//
//  RedSettingViewController.m
//  autoGetRedEnv
//
//  Created by 李向阳 on 2016/11/4.
//
//

#import "RedSettingViewController.h"
#import <objc/runtime.h>
#import "JRSwizzle.h"

void injected_function(void);

__attribute((constructor)) void injected_function(){
    [[NSNotificationCenter defaultCenter] addObserver:[RedSettingViewController sharedInstance]
                                             selector:@selector(appDidFinished)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
}

@interface RedSettingViewController ()
@property (nonatomic, strong) NSMutableDictionary *settingInfo;

@property (weak, nonatomic) IBOutlet UISwitch  *redBagSwitch;
@property (weak, nonatomic) IBOutlet UISwitch  *selfBagSwitch;
@property (weak, nonatomic) IBOutlet UISwitch  *selfSendGroupBagSwitch;
@property (weak, nonatomic) IBOutlet UISwitch  *otherSendGroupBagSwitch;

@property (weak, nonatomic) IBOutlet UISwitch  *delayRandomSwitch;
@property (weak, nonatomic) IBOutlet UILabel   *delayTimeLabel;
@property (weak, nonatomic) IBOutlet UIStepper *delayTimeSteps;

@property (weak, nonatomic) IBOutlet UISwitch  *revokedMessageSwitch;


@end

@implementation RedSettingViewController

static RedSettingViewController *_sharedInstance = nil;
    
+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[UIStoryboard storyboardWithName:@"RedBag" bundle:nil] instantiateInitialViewController];
        [_sharedInstance loadSetting];
    });
    return _sharedInstance;
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
        
//        [UINavigationController jr_swizzleMethod:@selector(pushViewController:animated:) withMethod:@selector(xy_pushViewController:animated:) error:nil];
        
    });
}
    
- (void)loadSetting
{
    __weak RedSettingViewController *weakSelf = self;
    [self.settingInfo enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [weakSelf setValue:obj forKey:key];
    }];
    
    if ([self.settingInfo count]>0) {
        self.redBagSwitch.on = [self.redState boolValue];
        self.selfBagSwitch.on = [self.selfState boolValue];
        self.selfSendGroupBagSwitch.on = [self.selfSendGroupState boolValue];
        self.otherSendGroupBagSwitch.on = [self.otherSendGroupState boolValue];
        self.delayRandomSwitch.on = [self.delayRandomState boolValue];
        
        self.delayTimeLabel.text = self.delayTime;
        self.delayTimeSteps.value = [self.delayTime doubleValue];
        
        self.revokedMessageSwitch.on = [self.revokeState boolValue];
    }
    
    [self stepsChanged];
    [self delayRandomChanged];
    [self redChanged];
}
    
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.delayTimeSteps addTarget:self action:@selector(stepsChanged) forControlEvents:UIControlEventValueChanged];
    [self.redBagSwitch addTarget:self action:@selector(redChanged) forControlEvents:UIControlEventValueChanged];
    [self.delayRandomSwitch addTarget:self action:@selector(delayRandomChanged) forControlEvents:UIControlEventValueChanged];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadSetting];
    self.navigationItem.title = @"红包设置";
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = [paths objectAtIndex:0];
    if (docDir){
        NSString *path = [docDir stringByAppendingPathComponent:@"RedSettings.plist"];
        [self.settingInfo setObject:@(self.redBagSwitch.isOn) forKey:@"redState"];
        [self.settingInfo setObject:@(self.selfBagSwitch.isOn) forKey:@"selfState"];
        [self.settingInfo setObject:@(self.selfSendGroupBagSwitch.isOn) forKey:@"selfSendGroupState"];
        [self.settingInfo setObject:@(self.otherSendGroupBagSwitch.isOn) forKey:@"otherSendGroupState"];
        [self.settingInfo setObject:@(self.delayRandomSwitch.isOn) forKey:@"delayRandomState"];
        [self.settingInfo setObject:self.delayTimeLabel.text forKey:@"delayTime"];
        
        [self.settingInfo setObject:@(self.revokedMessageSwitch.isOn) forKey:@"revokeState"];
        
        [self.settingInfo writeToFile:path atomically:YES];
        
        __weak RedSettingViewController *weakSelf = self;
        [self.settingInfo enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            [weakSelf setValue:obj forKey:key];
        }];
        
    }
}
    
- (void)stepsChanged
{
    self.delayTimeLabel.text = [@(self.delayTimeSteps.value) stringValue];
}

- (void)redChanged
{
    self.selfBagSwitch.enabled = self.redBagSwitch.isOn;
    self.selfSendGroupBagSwitch.enabled = self.redBagSwitch.isOn;
    self.otherSendGroupBagSwitch.enabled = self.redBagSwitch.isOn;
    
    self.delayRandomSwitch.enabled = self.redBagSwitch.isOn;
    self.delayTimeSteps.enabled = self.redBagSwitch.isOn;
}
    
- (void)delayRandomChanged
{
    self.delayTimeSteps.enabled = !self.delayRandomSwitch.isOn;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end

//@interface UINavigationController (RedBag)
//- (void)xy_pushViewController:(UIViewController*)vc animated:(BOOL)animated;
//@end
//
//@implementation UINavigationController (RedBag)
//
//- (void)xy_pushViewController:(UIViewController *)vc animated:(BOOL)animated
//{
//    [self xy_pushViewController:vc animated:animated];
//    
//}
//
//@end
