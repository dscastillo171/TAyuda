//
//  LugaresTableViewController.m
//  TAyuda
//
//  Created by Santiago Castillo on 1/31/16.
//  Copyright © 2016 tayuda. All rights reserved.
//

#import "LugaresTableViewController.h"

@interface LugaresTableViewController ()

@property (weak, nonatomic) TAyuda *tAyuda;

@property (strong, nonatomic) NSArray *lugares;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *menuButton;

@end

@implementation LugaresTableViewController

- (TAyuda *)tAyuda{
    if(!_tAyuda){
        _tAyuda = [(AppDelegate *)[[UIApplication sharedApplication] delegate] tAyuda];
    }
    return _tAyuda;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.backgroundColor = [UIColor colorWithWhite:250/255.0 alpha:1.0];
    
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 50)];
    textLabel.numberOfLines = 2;
    textLabel.backgroundColor = self.color;
    textLabel.text = self.tramite.nombre;
    textLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    textLabel.textColor = [UIColor whiteColor];
    textLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    textLabel.font = [UIFont fontWithName:@"FrutigerLTStd-Bold" size:[textLabel.font pointSize]];
    textLabel.textAlignment = NSTextAlignmentCenter;
    self.tableView.tableHeaderView = textLabel;
    
    SWRevealViewController *revealController = self.revealViewController;
    if(revealController){
        revealController.rightViewRevealWidth = 240;
        [self.menuButton setTarget:revealController];
        [self.menuButton setAction:@selector(rightRevealToggle:)];
    }
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    SWRevealViewController *revealController = self.revealViewController;
    if(revealController){
        [self.tableView addGestureRecognizer:revealController.panGestureRecognizer];
        [self.tableView addGestureRecognizer:revealController.tapGestureRecognizer];
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    SWRevealViewController *revealController = self.revealViewController;
    if(revealController){
        [self.tableView removeGestureRecognizer:revealController.panGestureRecognizer];
        [self.tableView removeGestureRecognizer:revealController.tapGestureRecognizer];
    }
}

- (void)setTramite:(Tramite *)tramite{
    _tramite = tramite;
    if([tramite.lugares count] > 0){
        self.lugares = [[tramite.lugares allObjects] sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            if(((Lugar *)obj1).id > ((Lugar *)obj2).id){
                return (NSComparisonResult)NSOrderedDescending;
            } else if(((Lugar *)obj1).id < ((Lugar *)obj2).id){
                return (NSComparisonResult)NSOrderedAscending;
            } else{
                return (NSComparisonResult)NSOrderedSame;
            }
        }];
    }
    [self.tAyuda updateLugaresForTramite:tramite completionBlock:^(BOOL completed) {
        if(completed){
            dispatch_async(dispatch_get_main_queue(), ^{
                [[_tramite managedObjectContext] refreshObject:_tramite mergeChanges:NO];
                self.lugares = [[_tramite.lugares allObjects] sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                    if(((Lugar *)obj1).id > ((Lugar *)obj2).id){
                        return (NSComparisonResult)NSOrderedDescending;
                    } else if(((Lugar *)obj1).id < ((Lugar *)obj2).id){
                        return (NSComparisonResult)NSOrderedAscending;
                    } else{
                        return (NSComparisonResult)NSOrderedSame;
                    }
                }];
                [self.tableView reloadData];
            });
        }
    }];
}

- (IBAction)openSearch:(id)sender {
    UINavigationController *searchController = [self.storyboard instantiateViewControllerWithIdentifier:@"SearchTableViewController"];
    [searchController setNavigationBarHidden:YES];
    [self presentViewController:searchController animated:YES completion:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(self.lugares){
        return [self.lugares count];
    } else{
        return 1;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    if(self.lugares){
        cell = [tableView dequeueReusableCellWithIdentifier:@"LugarTableViewCell" forIndexPath:indexPath];
        Lugar *lugar = [self.lugares objectAtIndex:indexPath.row];
        [(LugarTableViewCell *)cell setUpWithLugar:lugar];
    } else{
        cell = [tableView dequeueReusableCellWithIdentifier:@"LoadingTableViewCell" forIndexPath:indexPath];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(self.lugares){
        return [LugarTableViewCell heightOfCell];
    } else{
        return self.view.bounds.size.height - [self.topLayoutGuide length];
    }
}

@end
