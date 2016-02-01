//
//  TemasCollectionViewController.m
//  TAyuda
//
//  Created by Santiago Castillo on 11/17/15.
//  Copyright © 2015 tayuda. All rights reserved.
//

#import "TemasCollectionViewController.h"

@interface TemasCollectionViewController ()

@property (weak, nonatomic) TAyuda *tAyuda;

@property (strong, nonatomic) NSFetchedResultsController *contentController;

@property NSMutableArray *itemChanges;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *menuButton;

@end

@implementation TemasCollectionViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.collectionView.backgroundColor = [UIColor colorWithWhite:250/255.0 alpha:1.0];
    
    SWRevealViewController *revealController = self.revealViewController;
    if(revealController){
        revealController.rightViewRevealWidth = 240;
        [self.menuButton setTarget:revealController];
        [self.menuButton setAction:@selector(rightRevealToggle:)];
    }
    
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] displayBanner];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    SWRevealViewController *revealController = self.revealViewController;
    if(revealController){
        [self.collectionView addGestureRecognizer:revealController.panGestureRecognizer];
        [self.collectionView addGestureRecognizer:revealController.tapGestureRecognizer];
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    SWRevealViewController *revealController = self.revealViewController;
    if(revealController){
        [self.collectionView removeGestureRecognizer:revealController.panGestureRecognizer];
        [self.collectionView removeGestureRecognizer:revealController.tapGestureRecognizer];
    }
}

- (TAyuda *)tAyuda{
    if(!_tAyuda){
        _tAyuda = [(AppDelegate *)[[UIApplication sharedApplication] delegate] tAyuda];
    }
    return _tAyuda;
}

- (NSFetchedResultsController *)contentController{
    if(!_contentController){
        __weak TemasCollectionViewController *weakSelf = self;
        _contentController = [Tema getFetchedResultsController:[self.tAyuda getMainContext]];
        _contentController.delegate = weakSelf;
    }
    return _contentController;
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    self.contentController.delegate = nil;
    self.contentController = nil;
}

- (void)dealloc{
    if(_contentController){
        _contentController.delegate = nil;
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([[segue identifier] isEqualToString:@"SubtemaSegue"] && [sender isKindOfClass:[Tema class]]){
        SubtemasTableViewController *controller = [segue destinationViewController];
        controller.tema = sender;
        controller.position = [self.contentController indexPathForObject:sender].row;
    } else if([[segue identifier] isEqualToString:@"TramitesSegue"]  && [sender isKindOfClass:[Tema class]]){
        TramitesTableViewController *controller = [segue destinationViewController];
        controller.tema = sender;
        controller.temaColor = [MediaHandler colorForPosition:[self.contentController indexPathForObject:sender].row];
    }
    UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithTitle:@"Atrás" style:UIBarButtonItemStylePlain target:nil action:nil];
    [[self navigationItem] setBackBarButtonItem:newBackButton];
}

- (IBAction)openSearch:(UIBarButtonItem *)sender {
    UINavigationController *searchController = [self.storyboard instantiateViewControllerWithIdentifier:@"SearchTableViewController"];
    [searchController setNavigationBarHidden:YES];
    [self presentViewController:searchController animated:YES completion:nil];
}

- (BOOL)dataAvailable{
    id<NSFetchedResultsSectionInfo> sectionObj = [[self.contentController sections] objectAtIndex:0];
    return [sectionObj numberOfObjects] > 0;
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    NSInteger count;
    if([self dataAvailable]){
        count = [[self.contentController sections] count];
    } else{
        count = 1;
    }
    return count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSInteger count;
    if([self dataAvailable]){
        id<NSFetchedResultsSectionInfo> sectionObj = [[self.contentController sections] objectAtIndex:section];
        count = [sectionObj numberOfObjects];
    } else{
        count = 1;
    }
    return count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell;
    if([self dataAvailable]){
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TemaCollectionViewCell" forIndexPath:indexPath];
        [(TemaCollectionViewCell *)cell setPosition:indexPath.row];
        Tema *tema = [self.contentController objectAtIndexPath:indexPath];
        [(TemaCollectionViewCell *)cell setUpWithTema:tema];
        [cell setNeedsDisplay];
    } else{
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LoadingCollectionViewCell" forIndexPath:indexPath];
    }
    return cell;
}

#pragma mark <UICollectionViewDelegateFlowLayout>

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGSize size;
    if([self dataAvailable]){
        CGFloat width = (self.view.bounds.size.width - 2.0) / 2.0;
        CGFloat height = ceilf((self.view.bounds.size.height - [self.topLayoutGuide length] - (2.0 * 4)) / 5.0);
        size = CGSizeMake(width, height);
    } else{
        size = self.view.bounds.size;
        size.height -= [self.topLayoutGuide length];
    }
    return size;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 2.0;
}

#pragma mark - <NSFetchedControllerDelegate>

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller{
    _itemChanges = [[NSMutableArray alloc] init];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    NSMutableDictionary *change = [[NSMutableDictionary alloc] init];
    switch(type) {
        case NSFetchedResultsChangeInsert:
            change[@(type)] = newIndexPath;
            break;
        case NSFetchedResultsChangeDelete:
            change[@(type)] = indexPath;
            break;
        case NSFetchedResultsChangeUpdate:
            change[@(type)] = indexPath;
            break;
        case NSFetchedResultsChangeMove:
            change[@(type)] = @[indexPath, newIndexPath];
            break;
    }
    [_itemChanges addObject:change];
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.collectionView performBatchUpdates:^{
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:0];
        UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:indexPath];
        if(![cell isKindOfClass:[TemaCollectionViewCell class]]){
            [self.collectionView deleteItemsAtIndexPaths:@[indexPath]];
        }
        
        for (NSDictionary *change in _itemChanges) {
            [change enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                NSFetchedResultsChangeType type = [key unsignedIntegerValue];
                switch(type) {
                    case NSFetchedResultsChangeInsert:
                        [self.collectionView insertItemsAtIndexPaths:@[obj]];
                        break;
                    case NSFetchedResultsChangeDelete:
                        [self.collectionView deleteItemsAtIndexPaths:@[obj]];
                        break;
                    case NSFetchedResultsChangeUpdate:
                        [self.collectionView reloadItemsAtIndexPaths:@[obj]];
                        break;
                    case NSFetchedResultsChangeMove:
                        [self.collectionView deleteItemsAtIndexPaths:@[obj[0]]];
                        [self.collectionView insertItemsAtIndexPaths:@[obj[1]]];
                        break;
                }
            }];
        }
    } completion:^(BOOL finished) {
        _itemChanges = nil;
    }];
}

#pragma mark <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    Tema *tema = [self.contentController objectAtIndexPath:indexPath];
    if([tema.nombre isEqualToString:@"TU CONSULTA"]){
        [self performSegueWithIdentifier:@"TuConsultaSegue" sender:tema];
    } else if([tema.nombre isEqualToString:@"TU TRAMITE"]){
        [self performSegueWithIdentifier:@"TramitesSegue" sender:tema];
    }else{
        [self performSegueWithIdentifier:@"SubtemaSegue" sender:tema];
    }
}

@end
