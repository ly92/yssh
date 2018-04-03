//
//  AppLocation.m
//  gaibianjia
//
//  Created by PURPLEPENG on 9/21/15.
//  Copyright (c) 2015 Geek Zoo Studio. All rights reserved.
//

#import "AppLocation.h"
#import "BaiduLocation.h"
//#import "CityListModel.h"

#pragma mark -

NSString *const GetLocationSucceedNotification = @"GetLocationSucceedNotification";
NSString *const GetReverseCodeSucceedNotification = @"GetReverseCodeSucceedNotification";
NSString *const DidChangeCurrentLocationNotification = @"DidChangeCurrentLocationNotification";

#pragma mark -

@implementation AppLocation

@def_singleton( AppLocation )


- (Location *)location
{
    Location * location = [Location new];
    
    if ( [BaiduLocation sharedLocation].location.coordinate.latitude == 0 )
    {
        location.lat = @(39.897445);
    }
    else
    {
        location.lat = @([BaiduLocation sharedLocation].location.coordinate.latitude);
    }
    
    if ( [BaiduLocation sharedLocation].location.coordinate.longitude == 0 )
    {
        location.lon = @(116.331398);
    }
    else
    {
        location.lon = @([BaiduLocation sharedLocation].location.coordinate.longitude);
    }
    
    return location;
}


@end
