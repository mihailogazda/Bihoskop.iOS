//
//  AppDelegate.m
//  bihoskop2
//
//  Created by Mihailo Gazda on 7/22/12.
//  Copyright (c) 2012 Mihailo Gazda. All rights reserved.
//

#import "AppDelegate.h"

#import "FirstViewController.h"
#import "SecondViewController.h"
#import "BioskopiViewController.h"

bool globalFirstStart = false;
bool globalShouldRefresh = true;
NSString *const FBSessionStateChangedNotification = @"com.example.Login:FBSessionStateChangedNotification";

FBSession* globalSession = NULL;

@implementation AppDelegate

// UIAlertView helper for post buttons
- (void)showAlert:(NSString *)message
           result:(id)result
            error:(NSError *)error {
    
    NSString *alertMsg;
    NSString *alertTitle;
    if (error) {
        alertMsg = error.localizedDescription;
        alertTitle = @"Error";
    } else {
        alertMsg = [NSString stringWithFormat:@"Uspješno ste ostavili Facebook komentar za film \"%@\"!", [[NSUserDefaults standardUserDefaults] objectForKey:@"fb_naziv"]];
        alertTitle = @"Bihoskop";
    }
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:alertTitle
                                                        message:alertMsg
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
    [alertView show];
}

/*
 * Callback for session changes.
 */
- (void)sessionStateChanged:(FBSession *)session
                      state:(FBSessionState) state
                      error:(NSError *)error
{
    NSLog(@"State changed: %d", state);
    
    switch (state) {
        case FBSessionStateOpen:
            if (!error) {
                // We have a valid session
                NSLog(@"User session found");
                globalSession = session;
                
                NSString* fb_movieName = [[NSUserDefaults standardUserDefaults] objectForKey:@"fb_naziv"];
                NSString* fb_poster = [[NSUserDefaults standardUserDefaults] objectForKey:@"fb_poster"];
                NSString* fb_imdb = [[NSUserDefaults standardUserDefaults] objectForKey:@"fb_imdb"];
                NSString* fb_sadrzaj = [[NSUserDefaults standardUserDefaults] objectForKey:@"fb_sadrzaj"];
                NSString* fb_zanr = [[NSUserDefaults standardUserDefaults] objectForKey:@"fb_zanr"];

                NSMutableDictionary *postParams =
                [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                 fb_imdb, @"link",
                 fb_poster, @"picture",
                 fb_movieName, @"name",
                 fb_zanr, @"caption",
                 fb_sadrzaj, @"description",
                 nil];
                
                [postParams setObject:@"Idem gledati ovo definitivno" forKey:@"message"];
                [FBRequestConnection
                 startWithGraphPath:@"me/feed"
                 parameters: postParams
                 HTTPMethod:@"POST"
                 completionHandler:^(FBRequestConnection *connection,
                                     id result,
                                     NSError *error) {
                     [self showAlert:nil result:result error:error];
                 }];
                
                
                

            }
            break;
        case FBSessionStateClosed:
        case FBSessionStateClosedLoginFailed:
            [FBSession.activeSession closeAndClearTokenInformation];
            break;
        default:
            break;
    }
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:FBSessionStateChangedNotification
     object:session];
    
    if (error) {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Error"
                                  message:error.localizedDescription
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
    }
}

/*
 * Opens a Facebook session and optionally shows the login UX.
 */
- (BOOL)openSessionWithAllowLoginUI:(BOOL)allowLoginUI {
    
    NSArray *permissions = [[NSArray alloc] initWithObjects:
                            @"publish_stream",
                            nil];
    
    [FBSession setDefaultAppID:@"193979514066336"];
    return [FBSession openActiveSessionWithPermissions:permissions
                                          allowLoginUI:allowLoginUI
                                     completionHandler:^(FBSession *session,
                                                         FBSessionState state,
                                                         NSError *error) {
                                         [self sessionStateChanged:session
                                                             state:state
                                                             error:error];
                                     }];
}

// FBSample logic
// If we have a valid session at the time of openURL call, we handle Facebook transitions
// by passing the url argument to handleOpenURL; see the "Just Login" sample application for
// a more detailed discussion of handleOpenURL
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    // attempt to extract a token from the url
    
    return [FBSession.activeSession handleOpenURL:url];
}


// Pre iOS 4.2 support
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return [FBSession.activeSession handleOpenURL:url];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [application setStatusBarStyle:UIStatusBarStyleBlackOpaque];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    UIViewController *viewController1, *viewController2, *viewController3;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        viewController1 = [[FirstViewController alloc] initWithNibName:@"FirstViewController_iPhone" bundle:nil];
        viewController2 = [[SecondViewController alloc] initWithNibName:@"SecondViewController_iPhone" bundle:nil];
        viewController3 = [[BioskopiViewController alloc] initWithNibName:@"Bioskopi_iPhone" bundle:nil];
    }
    
    NSString* kino = [[NSUserDefaults standardUserDefaults] objectForKey:@"izabranoKino"];    
    NSLog(@"Izabrano kino: %@", kino);
    
    FirstViewController *first = (FirstViewController*)viewController1;
    BioskopiViewController *bioskop = (BioskopiViewController*)viewController3;
    [bioskop setFirstView: first];
    
    self.tabBarController = [[UITabBarController alloc] init];
    self.tabBarController.viewControllers = @[viewController1, viewController2, viewController3];
    self.window.rootViewController = self.tabBarController;
    [self.window makeKeyAndVisible];
    
    if (!kino){
        globalFirstStart = true;
        [self.tabBarController setSelectedIndex:2];
    }
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [FBSession.activeSession close];
}

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
}
*/

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed
{
}
*/

@end
