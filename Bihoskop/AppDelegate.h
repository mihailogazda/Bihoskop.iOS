//
//  AppDelegate.h
//  bihoskop2
//
//  Created by Mihailo Gazda on 7/22/12.
//  Copyright (c) 2012 Mihailo Gazda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>


@interface AppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate>
{

}

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) UITabBarController *tabBarController;

- (BOOL)openSessionWithAllowLoginUI:(BOOL)allowLoginUI ;


@end
