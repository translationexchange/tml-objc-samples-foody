//
//  AppDelegate.m
//  Foody
//
//  Created by Michael Berkovich on 10/13/15.
//  Copyright © 2015 Translation Exchange, Inc. All rights reserved.
//

#import "AppDelegate.h"
#import "APIClient.h"

@interface AppDelegate ()
@property (strong, readwrite, nonatomic) APIClient *apiClient;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.apiClient = [[APIClient alloc] initWithBaseURL:[NSURL URLWithString:@"http://localhost:5000/api/v1/"]];
    
    // Dynamic Splash
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSArray *backgroundPaths = [mainBundle pathsForResourcesOfType:@"jpg" inDirectory:@"Intro Backgrounds"];
    UIWindow *window = self.window;
    
//    UIViewController *splashViewController = window.rootViewController;
//    UIImageView *splashImageView = nil;
//    if (splashViewController != nil) {
//        for (UIView *subview in [splashViewController.view subviews]) {
//            if ([subview isKindOfClass:[UIImageView class]] == YES) {
//                splashImageView = (UIImageView *)subview;
//                break;
//            }
//        }
//    }
//    
//    UIImage *newImage = nil;
//    if (splashImageView != nil) {
//        NSInteger index = (arc4random() % backgroundPaths.count);
//        NSString *newImagePath = [backgroundPaths objectAtIndex:index];
//        newImage = [UIImage imageWithContentsOfFile:newImagePath];
//    }
//    
//    if (newImage != nil) {
//        splashImageView.image = newImage;
//        [splashImageView setNeedsLayout];
//    }
//    
//    [NSThread sleepForTimeInterval:1.33];
    
    UIStoryboard *launchScreenStoryBoard = [UIStoryboard storyboardWithName:@"LaunchScreen" bundle:mainBundle];
    UIViewController *splashViewController = [launchScreenStoryBoard instantiateInitialViewController];
    NSArray *subviews = [splashViewController.view subviews];
    UIImageView *splashImageView = nil;
    for (UIView *subview in subviews) {
        if ([subview isKindOfClass:[UIImageView class]] == YES) {
            CGRect frame = subview.frame;
            if (CGPointEqualToPoint(CGPointZero, frame.origin) == YES) {
                splashImageView = (UIImageView *)subview;
                break;
            }
        }
    }
    
    UIImage *newImage = nil;
    if (splashImageView != nil) {
        NSInteger index = (arc4random() % backgroundPaths.count);
        NSString *newImagePath = [backgroundPaths objectAtIndex:index];
        newImage = [UIImage imageWithContentsOfFile:newImagePath];
    }
    
    if (newImage != nil) {
        splashImageView.image = newImage;
        splashImageView.hidden = NO;
        [window setRootViewController:splashViewController];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.33 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:mainBundle];
            UIViewController *appViewController = [mainStoryBoard instantiateInitialViewController];
            [window setRootViewController:appViewController];
        });
    }
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
