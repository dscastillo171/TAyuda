//
//  TramiteViewController.h
//  TAyuda
//
//  Created by Santiago Castillo on 12/15/15.
//  Copyright © 2015 tayuda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWRevealViewController.h"
#import "AppDelegate.h"
#import "Tramite.h"
#import "PreguntaTableViewCell.h"
#import "LugaresTableViewController.h"

@interface TramiteViewController : UITableViewController

@property (strong, nonatomic) Tramite *tramite;

@property (nonatomic) UIColor *color;

@end
