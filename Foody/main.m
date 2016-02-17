//
//  main.m
//  Foody
//
//  Created by Michael Berkovich on 10/13/15.
//  Copyright © 2015 Translation Exchange, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

#define TML_APPLICATION_KEY @""
#define TML_APPLICATION_ACCESS_TOKEN @""

int main(int argc, char * argv[]) {
    @autoreleasepool {
        TMLConfiguration *config = [[TMLConfiguration alloc] initWithApplicationKey:TML_APPLICATION_KEY
                                                                        accessToken:TML_APPLICATION_ACCESS_TOKEN];
#if DEBUG
        config.translationEnabled = YES;
#endif
        [TML sharedInstanceWithConfiguration:config];
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
