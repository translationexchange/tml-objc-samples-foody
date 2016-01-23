//
//  AppDelegate.h
//  Foody
//
//  Created by Michael Berkovich on 10/13/15.
//  Copyright © 2015 Translation Exchange, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#define AppAPIClient (APIClient *)[(AppDelegate *)[[UIApplication sharedApplication] delegate] apiClient]

@class APIClient;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (readonly, nonatomic, strong) APIClient *apiClient;

@end

