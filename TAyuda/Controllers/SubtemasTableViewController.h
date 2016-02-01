//
//  BasicTableViewController.h
//  TAyuda
//
//  Created by Santiago Castillo on 11/17/15.
//  Copyright © 2015 tayuda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWRevealViewController.h"
#import "AppDelegate.h"
#import "SubtemaTableViewCell.h"
#import "Subtema.h"
#import "SubtemaViewController.h"

@interface SubtemasTableViewController : UITableViewController <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) Tema *tema;

@property (nonatomic) NSInteger position;

@end
