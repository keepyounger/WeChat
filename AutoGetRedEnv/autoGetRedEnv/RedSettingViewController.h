//
//  RedSettingViewController.h
//  autoGetRedEnv
//
//  Created by 李向阳 on 2016/11/4.
//
//

#import <UIKit/UIKit.h>

@interface RedSettingViewController : UITableViewController

+ (instancetype)sharedInstance;

@property (nonatomic, strong) NSString *redState;
@property (nonatomic, strong) NSString *selfState;
@property (nonatomic, strong) NSString *selfSendGroupState;
@property (nonatomic, strong) NSString *otherSendGroupState;
@property (nonatomic, strong) NSString *delayRandomState;
@property (nonatomic, strong) NSString *delayTime;

@property (nonatomic, strong) NSString *revokeState;
    
@end
