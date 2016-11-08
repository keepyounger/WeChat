//
//  RedManager.h
//  autoGetRedEnv
//
//  Created by 李向阳 on 2016/11/8.
//
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface RedManager : NSObject

+ (instancetype)sharedManager;

@property (nonatomic, strong) NSString *redState;
@property (nonatomic, strong) NSString *selfState;

@property (nonatomic, strong) NSString *delayRandomState;
@property (nonatomic, strong) NSString *delayTime;

@property (nonatomic, strong) NSString *revokeState;

@property (nonatomic, strong) NSString *locationStr;
@property (nonatomic, readonly) CLLocationCoordinate2D location;
@property (nonatomic, strong) NSString *locationState;

- (void)saveSetting;

@end
