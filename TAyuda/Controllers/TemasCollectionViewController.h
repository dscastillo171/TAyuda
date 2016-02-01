//
//  TemasCollectionViewController.h
//  TAyuda
//
//  Created by Santiago Castillo on 11/17/15.
//  Copyright © 2015 tayuda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWRevealViewController.h"
#import "AppDelegate.h"
#import "TemaCollectionViewCell.h"
#import "Tema.h"
#import "SubtemasTableViewController.h"
#import "TramitesTableViewController.h"

@interface TemasCollectionViewController : UICollectionViewController <NSFetchedResultsControllerDelegate, UICollectionViewDelegateFlowLayout>

@end
