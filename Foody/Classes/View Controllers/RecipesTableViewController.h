//
//  RecipesTableViewController.h
//  Foody
//
//  Created by Michael Berkovich on 10/15/15.
//  Copyright © 2015 Translation Exchange, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FCategory.h"

@interface RecipesTableViewController : UITableViewController

@property(nonatomic, strong) FCategory *category;

@end
