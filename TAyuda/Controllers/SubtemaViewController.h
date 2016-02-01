//
//  SubtemaViewController.h
//  TAyuda
//
//  Created by Santiago Castillo on 11/24/15.
//  Copyright © 2015 tayuda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWRevealViewController.h"
#import "AppDelegate.h"
#import "Subtema.h"
#import "PreguntaTableViewCell.h"

@interface SubtemaViewController : UITableViewController

@property (strong, nonatomic) Subtema *subtema;

@property (nonatomic) NSInteger position;

@end
