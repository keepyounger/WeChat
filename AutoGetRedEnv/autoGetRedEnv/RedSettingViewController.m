//
//  RedSettingViewController.m
//  autoGetRedEnv
//
//  Created by 李向阳 on 2016/11/4.
//
//

#import "RedSettingViewController.h"
#import "SelectionLocationViewController.h"
#import "RedManager.h"

@interface RedSettingViewController ()

@property (weak, nonatomic) IBOutlet UISwitch  *redBagSwitch;
@property (weak, nonatomic) IBOutlet UISwitch  *selfBagSwitch;

@property (weak, nonatomic) IBOutlet UISwitch  *delayRandomSwitch;
@property (weak, nonatomic) IBOutlet UILabel   *delayTimeLabel;
@property (weak, nonatomic) IBOutlet UIStepper *delayTimeSteps;

@property (weak, nonatomic) IBOutlet UISwitch  *revokedMessageSwitch;

@property (weak, nonatomic) IBOutlet UISwitch *locationSwitch;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;

@end

@implementation RedSettingViewController

+ (instancetype)defaultController
{
    RedSettingViewController *vc = [[UIStoryboard storyboardWithName:@"RedBag" bundle:nil] instantiateInitialViewController];
    return vc;
}
    
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.navigationItem.title = @"扩展设置";
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    [self.delayTimeSteps addTarget:self action:@selector(stepsChanged) forControlEvents:UIControlEventValueChanged];
    [self.redBagSwitch addTarget:self action:@selector(redChanged) forControlEvents:UIControlEventValueChanged];
    [self.delayRandomSwitch addTarget:self action:@selector(delayRandomChanged) forControlEvents:UIControlEventValueChanged];
    
    [self loadSetting];
}

- (void)loadSetting
{
    RedManager *manager = [RedManager sharedManager];
    
    self.redBagSwitch.on = [manager.redState boolValue];
    self.selfBagSwitch.on = [manager.selfState boolValue];

    self.delayRandomSwitch.on = [manager.delayRandomState boolValue];
    self.delayTimeLabel.text = manager.delayTime;
    self.delayTimeSteps.value = [manager.delayTime doubleValue];
    
    self.revokedMessageSwitch.on = [manager.revokeState boolValue];
    
    self.locationSwitch.on = [manager.locationState boolValue];
    
    NSArray *array = [manager.locationStr componentsSeparatedByString:@","];
    
    if (array.count>=2) {
        self.locationLabel.text = array.lastObject;
    }
    
    [self stepsChanged];
    [self delayRandomChanged];
    [self redChanged];
    
}
    
- (void)stepsChanged
{
    self.delayTimeLabel.text = [@(self.delayTimeSteps.value) stringValue];
}

- (void)redChanged
{
    self.selfBagSwitch.enabled = self.redBagSwitch.isOn;
    
    self.delayRandomSwitch.enabled = self.redBagSwitch.isOn;
    self.delayTimeSteps.enabled = self.redBagSwitch.isOn;
}

- (void)delayRandomChanged
{
    self.delayTimeSteps.enabled = !self.delayRandomSwitch.isOn;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 3 && indexPath.row == 1) {
        SelectionLocationViewController *vc = [[SelectionLocationViewController alloc] init];
        
        UIBarButtonItem *back = [[UIBarButtonItem alloc] init];
        back.title = @"";
        self.navigationItem.backBarButtonItem = back;
        
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)save
{
    RedManager *manager = [RedManager sharedManager];

    manager.redState = @(self.redBagSwitch.on).stringValue;
    manager.selfState = @(self.selfBagSwitch.on).stringValue;

    manager.delayRandomState = @(self.delayRandomSwitch.on).stringValue;
    manager.delayTime = self.delayTimeLabel.text;
    
    manager.revokeState = @(self.revokedMessageSwitch.on).stringValue;
    manager.locationState = @(self.locationSwitch.on).stringValue;
    
    [manager saveSetting];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (![self.navigationController.viewControllers containsObject:self]) {
        [self save];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    RedManager *manager = [RedManager sharedManager];
    NSArray *array = [manager.locationStr componentsSeparatedByString:@","];
    if (array.count>=2) {
        self.locationLabel.text = array.lastObject;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
