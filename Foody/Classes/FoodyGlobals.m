//
//  FoodyGlobals.m
//  Foody
//
//  Created by Pasha on 2/11/16.
//  Copyright © 2016 Translation Exchange, Inc. All rights reserved.
//

#import "FoodyGlobals.h"

void UseAlternativeInstantiationMethod(SEL selector, id object) {
    [NSException raise:NSInvalidArgumentException format:@"Use -[%@ %@] instantiation method",
     [object class],
     NSStringFromSelector(selector)
     ];
}