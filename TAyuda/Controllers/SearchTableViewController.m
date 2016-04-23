//
//  SearchTableViewController.m
//  TAyuda
//
//  Created by Santiago Castillo on 11/25/15.
//  Copyright © 2015 tayuda. All rights reserved.
//

#import "SearchTableViewController.h"

#define HORIZONTAL_PADDING 6.0
#define VERTICAL_PADDING 12.0

@interface SearchTableViewController ()

@property (weak, nonatomic) TAyuda *tAyuda;

@property (strong, nonatomic) NSArray *preguntas;

@property (nonatomic) NSInteger expandedSection;

@property (strong, nonatomic) UISearchController *searchController;

@property (strong, nonatomic) NSTimer *searchTimer;

@property (strong, nonatomic) UIColor *tintColor;

@property (weak, nonatomic) UIView *coverView;

@property (strong, nonatomic) NSDate *now;

@end

@implementation SearchTableViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.tintColor = [MediaHandler colorForPosition: 4];
    
    self.tableView.backgroundColor = [UIColor colorWithWhite:250/255.0 alpha:1.0];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.expandedSection = -1;
    
    self.searchController = [[CustomUISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    self.searchController.searchBar.delegate = self;
    self.searchController.searchBar.placeholder = @"Ingresa aquí tu pregunta";
    [self.searchController.searchBar setValue:@"Cancelar" forKey:@"_cancelButtonText"];
    [self.searchController.searchBar setShowsCancelButton:YES animated:NO];
    self.searchController.searchBar.tintColor = self.tintColor;
    self.tableView.tableHeaderView = self.searchController.searchBar;
    self.definesPresentationContext = YES;
    
    [self.searchController.searchBar setSearchBarStyle:UISearchBarStyleMinimal];
    [self.searchController.searchBar setBackgroundColor:[UIColor colorWithWhite:238/255.0 alpha:1.0]];
    
    self.now = [NSDate date];
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    if(!self.coverView){
        CGFloat size = [UIApplication sharedApplication].statusBarFrame.size.height;
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, -size, self.view.bounds.size.width, size)];
        view.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        view.autoresizesSubviews = YES;
        view.backgroundColor = [UIColor colorWithWhite:238/255.0 alpha:1.0];
        [self.view addSubview:view];
        self.coverView = view;
    }
}

- (TAyuda *)tAyuda{
    if(!_tAyuda){
        _tAyuda = [(AppDelegate *)[[UIApplication sharedApplication] delegate] tAyuda];
    }
    return _tAyuda;
}

- (NSArray *)preguntas{
    if(!_preguntas){
        _preguntas = @[];
    }
    return _preguntas;
}

- (void)sectionTapped:(UIGestureRecognizer *)gestureRecognizer{
    UIView *sectionView = gestureRecognizer.view;
    NSInteger tag = sectionView.tag;
    if(tag >= 0){
        [self.tableView beginUpdates];
        if(self.expandedSection >= 0){
            [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:self.expandedSection]] withRowAnimation:UITableViewRowAnimationTop];
        }
        if(self.expandedSection == tag){
            self.expandedSection = -1;
        } else{
            self.expandedSection = tag;
            [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:self.expandedSection]] withRowAnimation:UITableViewRowAnimationTop];
        }
        [self.tableView endUpdates];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.preguntas count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger count = section == self.expandedSection? 1: 0;
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PreguntaTableViewCell" forIndexPath:indexPath];
    Pregunta *pregunta = [self.preguntas objectAtIndex:indexPath.section];
    [(PreguntaTableViewCell *)cell setButtonColor:self.tintColor];
    [(PreguntaTableViewCell *)cell setUpWithPregunta:pregunta];
    [cell setNeedsDisplay];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView;
    if([self.preguntas count] > 0){
        UILabel *labelView = [UILabel new];
        labelView.backgroundColor = [UIColor colorWithWhite:250/255.0 alpha:1.0];
        labelView.textColor = [UIColor colorWithWhite:66/255.0 alpha:1.0];
        labelView.font = [UIFont preferredFontForTextStyle: UIFontTextStyleBody];
        labelView.font = [UIFont fontWithName:@"FrutigerLTStd-Roman" size:[labelView.font pointSize]];
        labelView.numberOfLines = 0;
        
        Pregunta *pregunta = [self.preguntas objectAtIndex:section];
        NSString *text = pregunta.pregunta? [pregunta.pregunta stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]: @"";
        labelView.text = text;
        CGFloat width = self.view.bounds.size.width - (2 * HORIZONTAL_PADDING);
        CGFloat height = [SearchTableViewController heightOfText:text withWidth:width] + (VERTICAL_PADDING * 2);
        labelView.frame = CGRectMake(HORIZONTAL_PADDING, 0, width, height);
        
        UIView *border = [[UIView alloc] initWithFrame:CGRectMake(0, height - 0.5, self.view.bounds.size.width, 0.5)];
        border.backgroundColor = [UIColor colorWithWhite:224/255.0 alpha:1.0];
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, height)];
        view.backgroundColor = [UIColor colorWithWhite:245/255.0 alpha:1.0];
        view.tag = section;
        [view addSubview:labelView];
        [view addSubview:border];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sectionTapped:)];
        view.userInteractionEnabled = YES;
        [view addGestureRecognizer:tapGesture];
        headerView = view;
    }
    return headerView;
}

+ (CGFloat)heightOfText:(NSString *)text withWidth:(CGFloat)width{
    static NSDictionary *defaultAttributes;
    if(!defaultAttributes){
        UIFont *font = [UIFont preferredFontForTextStyle: UIFontTextStyleBody];
        defaultAttributes = [NSDictionary dictionaryWithObjectsAndKeys: [UIFont fontWithName:@"FrutigerLTStd-Roman" size:[font pointSize]], NSFontAttributeName, nil];
    }
    
    CGRect textRect = [text boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:defaultAttributes context:nil];
    return CGRectIntegral(textRect).size.height;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    Pregunta *pregunta = [self.preguntas objectAtIndex:indexPath.section];
    CGFloat height = [PreguntaTableViewCell heightOfPregunta:pregunta withWidth:self.view.bounds.size.width];
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    Pregunta *pregunta = [self.preguntas objectAtIndex:section];
    NSString *text = pregunta.pregunta? [pregunta.pregunta stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]: @"";
    CGFloat width = self.view.bounds.size.width - (2 * HORIZONTAL_PADDING);
    CGFloat height = [SearchTableViewController heightOfText:text withWidth:width] + (VERTICAL_PADDING * 2);
    return height;
}

#pragma mark - <UISearchResultsUpdating>

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController{
    NSString *text = searchController.searchBar.text;
    if(self.searchTimer){
        [self.searchTimer invalidate];
    }
    
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(updateSearch:) userInfo:text repeats:NO];
    self.searchTimer = timer;
}

- (void)updateSearch:(NSTimer *)timer{
    NSString *text = (NSString *)timer.userInfo;
    if(text.length){
        [self.tAyuda searchPreguntas:text completionBlock:^(NSArray *preguntas) {
            [[self.tAyuda getMainContext] performBlock:^{
                if([self.searchController.searchBar.text isEqualToString:text]){
                    self.preguntas = preguntas;
                    self.expandedSection = -1;
                    [self.tableView reloadData];
                }
            }];
        }];
    } else if(self.searchController.active){
        self.preguntas = @[];
        self.expandedSection = -1;
        [self.tableView reloadData];
    }
    
}

#pragma mark <UISearchBarDelegate>

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self.searchController setActive:NO];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
