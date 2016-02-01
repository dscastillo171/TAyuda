//
//  CustomUISearchController.m
//  TAyuda
//
//  Created by Santiago Castillo on 11/25/15.
//  Copyright © 2015 tayuda. All rights reserved.
//

#import "CustomUISearchController.h"

@interface CustomUISearchController ()

@property(nonatomic, strong) UISearchBar *searchBar;

@end

@implementation CustomUISearchController

@synthesize searchBar = _searchBar;
- (UISearchBar *)searchBar{
    if(!_searchBar){
        _searchBar = [[CancelButtonUISearchBar alloc] init];
    }
    return _searchBar;
}

@end
