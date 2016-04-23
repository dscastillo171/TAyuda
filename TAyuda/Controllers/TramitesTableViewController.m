//
//  TramitesTableViewController.m
//  TAyuda
//
//  Created by Santiago Castillo on 11/25/15.
//  Copyright © 2015 tayuda. All rights reserved.
//

#import "TramitesTableViewController.h"

@interface TramitesTableViewController ()

@property (weak, nonatomic) TAyuda *tAyuda;

@property (strong, nonatomic) NSFetchedResultsController *contentController;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *menuButton;

@end

@implementation TramitesTableViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.tableView.backgroundColor = [UIColor colorWithWhite:250/255.0 alpha:1.0];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    SWRevealViewController *revealController = self.revealViewController;
    if(revealController){
        revealController.rightViewRevealWidth = 240;
        [self.menuButton setTarget:revealController];
        [self.menuButton setAction:@selector(rightRevealToggle:)];
        [self.tableView addGestureRecognizer:revealController.panGestureRecognizer];
        [self.tableView addGestureRecognizer:revealController.tapGestureRecognizer];
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

- (TAyuda *)tAyuda{
    if(!_tAyuda){
        _tAyuda = [(AppDelegate *)[[UIApplication sharedApplication] delegate] tAyuda];
    }
    return _tAyuda;
}

- (NSFetchedResultsController *)contentController{
    if(!_contentController){
        __weak TramitesTableViewController *weakSelf = self;
        _contentController = [Tramite getFetchedResultsControllerInContext:[self.tAyuda getMainContext]];
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
    if([[segue identifier] isEqualToString:@"TramiteSegue"] && [sender isKindOfClass:[Tramite class]]){
        TramiteViewController *controller = [segue destinationViewController];
        controller.tramite = sender;
        controller.color = self.temaColor;
        
        UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithTitle:@"Atrás" style:UIBarButtonItemStylePlain target:nil action:nil];
        [[self navigationItem] setBackBarButtonItem:newBackButton];
    }
}

- (IBAction)openSearch:(UIBarButtonItem *)sender {
    UINavigationController *searchController = [self.storyboard instantiateViewControllerWithIdentifier:@"SearchTableViewController"];
    [searchController setNavigationBarHidden:YES];
    [self presentViewController:searchController animated:YES completion:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[self.contentController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id<NSFetchedResultsSectionInfo> sectionObj = [[self.contentController sections] objectAtIndex:section];
    return [sectionObj numberOfObjects];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SubtemaTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SubtemaTableViewCell" forIndexPath:indexPath];
    Tramite *tramite = (Tramite *)[self.contentController objectAtIndexPath:indexPath];
    [cell setUpWithTramite:tramite];
    [cell setBorderColor:[self.temaColor colorWithAlphaComponent:0.5]];
    [cell setNeedsDisplay];
    return cell;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    Tramite *tramite = (Tramite *)[self.contentController objectAtIndexPath:indexPath];
    CGFloat height = [SubtemaTableViewCell heightOfTramite:tramite withWidth:self.view.bounds.size.width];
    return height;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [UIView new];
    view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    view.backgroundColor = self.temaColor;
    
    UILabel *textLabel = [UILabel new];
    textLabel.text = self.tema.nombre;
    textLabel.textColor = [UIColor whiteColor];
    textLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    textLabel.font = [UIFont fontWithName:@"FrutigerLTStd-Bold" size:[textLabel.font pointSize]];
    textLabel.textAlignment = NSTextAlignmentCenter;
    [textLabel sizeToFit];
    [view addSubview:textLabel];
    
    CGSize viewSize = CGSizeMake(self.view.bounds.size.width, 60.0);
    CGRect textRect = textLabel.frame;
    UIImage *icon = [MediaHandler processSingleImage:[UIImage imageNamed:@"IconoTramites.png"] maxSize:50.0];
    if(icon){
        CGFloat imageSize = 48.0;
        CGFloat spacing = 12.0;
        CGFloat width = textRect.size.width + imageSize + spacing;
        textRect.origin = CGPointMake(((viewSize.width - width) / 2.0) + imageSize + spacing, (viewSize.height - textRect.size.height) / 2.0);
        textLabel.frame = textRect;
        
        UIImageView *imageView = [UIImageView new];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.image = icon;
        imageView.frame = CGRectMake((viewSize.width - width) / 2.0, (viewSize.height - imageSize) / 2.0, imageSize, imageSize);
        [view addSubview:imageView];
    } else{
        textRect.origin = CGPointMake((viewSize.width - textRect.size.width) / 2.0, (viewSize.height - textRect.size.height) / 2.0);
        textLabel.frame = textRect;
    }
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 60.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    Subtema *subtema = [self.contentController objectAtIndexPath:indexPath];
    [self performSegueWithIdentifier:@"TramiteSegue" sender:subtema];
}

@end
