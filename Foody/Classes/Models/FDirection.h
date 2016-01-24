//
//  FDirection.h
//  Foody
//
//  Created by Michael Berkovich on 10/14/15.
//  Copyright © 2015 Translation Exchange, Inc. All rights reserved.
//

#import <TMLKit/TMLModel.h>

@interface FDirection : TMLModel

@property (assign, nonatomic) NSInteger directionID;
@property (assign, nonatomic) NSInteger index;
@property (strong, nonatomic) NSString *directionDescription;

@end
