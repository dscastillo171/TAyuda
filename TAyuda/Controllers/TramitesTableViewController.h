//
//  TramitesTableViewController.h
//  TAyuda
//
//  Created by Santiago Castillo on 11/25/15.
//  Copyright © 2015 tayuda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWRevealViewController.h"
#import "AppDelegate.h"
#import "Tramite.h"
#import "SubtemaTableViewCell.h"
#import "TramiteViewController.h"

@interface TramitesTableViewController : UITableViewController <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) Tema *tema;
@property (strong, nonatomic) UIColor *temaColor;

@end
