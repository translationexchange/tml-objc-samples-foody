//
//  FoodyGlobals.h
//  Foody
//
//  Created by Pasha on 2/11/16.
//  Copyright © 2016 Translation Exchange, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

void UseAlternativeInstantiationMethod(SEL selector, id object);
#define RaiseAlternativeInstantiationMethod(selector) UseAlternativeInstantiationMethod(selector, self);
