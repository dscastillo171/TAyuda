//
//  SubtemaViewController.m
//  TAyuda
//
//  Created by Santiago Castillo on 11/24/15.
//  Copyright © 2015 tayuda. All rights reserved.
//

#import "SubtemaViewController.h"

#define HORIZONTAL_PADDING 6.0
#define VERTICAL_PADDING 12.0

@interface SubtemaViewController ()

@property (weak, nonatomic) TAyuda *tAyuda;

@property (strong, nonatomic) NSArray *preguntas;

@property (nonatomic) NSInteger expandedSection;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *menuButton;

@end

@implementation SubtemaViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.tableView.backgroundColor = [UIColor colorWithWhite:250/255.0 alpha:1.0];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 50)];
    textLabel.numberOfLines = 2;
    textLabel.backgroundColor = [MediaHandler colorForPosition:self.position];
    textLabel.text = self.subtema.nombre;
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

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.expandedSection = -1;
}

- (TAyuda *)tAyuda{
    if(!_tAyuda){
        _tAyuda = [(AppDelegate *)[[UIApplication sharedApplication] delegate] tAyuda];
    }
    return _tAyuda;
}

- (void)setSubtema:(Subtema *)subtema{
    _subtema = subtema;
    NSArray *preguntas = [Pregunta getAllPreguntasForSubtema:self.subtema inContext:[self.tAyuda getMainContext]];
    if([preguntas count] > 0){
        self.preguntas = preguntas;
    }
    [self updatePreguntas];
}

- (void)updatePreguntas{
    [self.tAyuda updatePreguntasForSubtema:self.subtema completionBlock:^(BOOL completed) {
        if(completed){
            [[self.tAyuda getMainContext] performBlock:^{
                NSArray *currentPreguntas = [Pregunta getAllPreguntasForSubtema:self.subtema inContext:[self.tAyuda getMainContext]];
                NSArray *newPreguntas = [TAyuda removeObjectsFromArray:currentPreguntas inArray:self.preguntas];
                [self.tableView beginUpdates];
                
                if(!self.preguntas){
                    [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
                    self.preguntas = [NSArray new];
                }
                
                for(Pregunta *pregunta in newPreguntas){
                    self.preguntas = [self.preguntas arrayByAddingObject:pregunta];
                    [self.tableView insertSections:[NSIndexSet indexSetWithIndex:[self.preguntas count] - 1] withRowAnimation:UITableViewRowAnimationFade];
                }
                
                [self.tableView endUpdates];
            }];
        } else{
            [self updatePreguntas];
        }
    }];
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

- (IBAction)openSearch:(id)sender {
    UINavigationController *searchController = [self.storyboard instantiateViewControllerWithIdentifier:@"SearchTableViewController"];
    [searchController setNavigationBarHidden:YES];
    [self presentViewController:searchController animated:YES completion:nil];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if(self.preguntas){
        return [self.preguntas count];
    } else{
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(self.preguntas){
        return section == self.expandedSection? 1: 0;
    } else{
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    if(self.preguntas){
        cell = [tableView dequeueReusableCellWithIdentifier:@"PreguntaTableViewCell" forIndexPath:indexPath];
        [(PreguntaTableViewCell *)cell setButtonColor:[MediaHandler colorForPosition:self.position]];
        Pregunta *pregunta = [self.preguntas objectAtIndex:indexPath.section];
        [(PreguntaTableViewCell *)cell setUpWithPregunta:pregunta];
        [cell setNeedsDisplay];
    } else{
        cell = [tableView dequeueReusableCellWithIdentifier:@"LoadingTableViewCell" forIndexPath:indexPath];
    }
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView;
    if(self.preguntas){
        UILabel *labelView = [UILabel new];
        labelView.backgroundColor = [UIColor colorWithWhite:250/255.0 alpha:1.0];
        labelView.textColor = [UIColor colorWithWhite:66/255.0 alpha:1.0];
        labelView.font = [UIFont preferredFontForTextStyle: UIFontTextStyleBody];
        labelView.font = [UIFont fontWithName:@"FrutigerLTStd-Light" size:[labelView.font pointSize]];
        labelView.numberOfLines = 0;
        
        Pregunta *pregunta = [self.preguntas objectAtIndex:section];
        NSString *text = pregunta.pregunta? [pregunta.pregunta stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]: @"";
        labelView.text = text;
        CGFloat width = self.view.bounds.size.width - (2 * HORIZONTAL_PADDING);
        CGFloat height = [SubtemaViewController heightOfText:text withWidth:width] + (VERTICAL_PADDING * 2);
        labelView.frame = CGRectMake(HORIZONTAL_PADDING, 0, width, height);
        
        UIView *border = [[UIView alloc] initWithFrame:CGRectMake(0, height - 0.5, self.view.bounds.size.width, 0.5)];
        border.backgroundColor = [UIColor colorWithWhite:224/255.0 alpha:1.0];
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, height)];
        view.backgroundColor = [UIColor colorWithWhite:250/255.0 alpha:1.0];
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
        defaultAttributes = [NSDictionary dictionaryWithObjectsAndKeys: [UIFont preferredFontForTextStyle:UIFontTextStyleBody], NSFontAttributeName, nil];
    }
    
    CGRect textRect = [text boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:defaultAttributes context:nil];
    return CGRectIntegral(textRect).size.height;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height;
    if(self.preguntas){
        Pregunta *pregunta = [self.preguntas objectAtIndex:indexPath.section];
        height = [PreguntaTableViewCell heightOfPregunta:pregunta withWidth:self.view.bounds.size.width];
    } else{
        height = self.view.bounds.size.height - [self.topLayoutGuide length] - 80.0;
    }
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(self.preguntas){
        Pregunta *pregunta = [self.preguntas objectAtIndex:section];
        NSString *text = pregunta.pregunta? [pregunta.pregunta stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]: @"";
        CGFloat width = self.view.bounds.size.width - (2 * HORIZONTAL_PADDING);
        CGFloat height = [SubtemaViewController heightOfText:text withWidth:width];
        return height + (VERTICAL_PADDING * 2);
    } else{
        return 0;
    }
}

@end
