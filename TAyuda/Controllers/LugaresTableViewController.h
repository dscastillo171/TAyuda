//
//  LugaresTableViewController.h
//  TAyuda
//
//  Created by Santiago Castillo on 1/31/16.
//  Copyright © 2016 tayuda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWRevealViewController.h"
#import "AppDelegate.h"
#import "Tramite.h"
#import "Lugar.h"
#import "LugarTableViewCell.h"

@interface LugaresTableViewController : UITableViewController

@property (strong, nonatomic) Tramite *tramite;

@property (nonatomic) UIColor *color;

@end
