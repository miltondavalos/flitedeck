//
//  SearchPopoverComponent.h
//  FliteDeck
//
//  Created by Evol Johnson on 2/20/12.
//  Copyright (c) 2012 NetJets. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchResultsTableViewController.h"
#import "NCLFramework.h"

@protocol SearchPopoverComponentDelegate
-(NSArray *) searchForItems : (NSString*) criteria;
@end

@interface SearchPopoverComponent : UIView <UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate> {
    SearchResultsTableViewController *searchResultsTableView;
    UISearchBar *searchBar;
    UIPopoverController *searchResultsPopover;
    bool hasSelectedItem;
    NSObject *selectedItem;
}

@property(nonatomic,strong) SearchResultsTableViewController *searchResultsTableView;
@property(nonatomic,strong) UISearchBar *searchBar;
@property(nonatomic,strong) UIPopoverController *searchResultsPopover;
@property(nonatomic,strong)  NSObject *selectedItem;

@property(nonatomic,strong)  NSString *sendNotificationWhenCleared;
@property(nonatomic,strong)  NSString *sendNotificationWhenSelected;
@property(nonatomic,strong)  NSString *sendNotificationWhenSearching;

@property(nonatomic,strong)  NSMutableArray *items;
@property(nonatomic,strong)  NSObject *delegate;
- (void)searchForItems:(UISearchBar *)searchBar;

@end
