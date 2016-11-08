//
//  CLLocation+Simulation.m
//  autoGetRedEnv
//
//  Created by 李向阳 on 2016/11/8.
//
//

#import "CLLocation+Simulation.h"
#import <objc/runtime.h>
#import "RedManager.h"

@implementation CLLocation (Simulation)

- (CLLocationCoordinate2D)xy_coordinate{
    RedManager *manager = [RedManager sharedManager];
    CLLocationCoordinate2D oldCoordinate = [self xy_coordinate];
    if (manager.locationState.boolValue && manager.location.latitude!=0 && manager.location.longitude!=0) {
        return manager.location;
    }
    return oldCoordinate;
    
}

@end
