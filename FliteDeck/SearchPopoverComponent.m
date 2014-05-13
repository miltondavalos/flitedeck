//
//  SearchPopoverComponent.m
//  FliteDeck
//
//  Created by Evol Johnson on 2/20/12.
//  Copyright (c) 2012 NetJets. All rights reserved.
//

#import "SearchPopoverComponent.h"

@implementation SearchPopoverComponent

@synthesize searchResultsTableView, searchBar, searchResultsPopover, selectedItem,sendNotificationWhenCleared,sendNotificationWhenSelected,sendNotificationWhenSearching, items,delegate;

#pragma mark - Initialization

- (void)baseInit {
    self.backgroundColor = [UIColor clearColor];
    
    hasSelectedItem = NO;

    CGRect searchBarFrame = CGRectMake(0, 0, 320, 44);
    self.searchBar = [[UISearchBar alloc] initWithFrame:searchBarFrame];
    self.searchBar.placeholder = @"Name, City or Code";
    self.searchBar.autocapitalizationType = UITextAutocapitalizationTypeWords;
    self.searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
    [[self.searchBar.subviews objectAtIndex:0] removeFromSuperview];
    self.searchBar.delegate = self;
    self.searchBar.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
    [self addSubview:self.searchBar];
    
    self.searchResultsTableView = [[SearchResultsTableViewController alloc] initWithNibName:@"SearchResultsTableViewController" bundle:nil];
    self.searchResultsTableView.tableView.dataSource = self;
    self.searchResultsTableView.tableView.delegate = self;
    [self.searchResultsTableView setPreferredContentSize:CGSizeMake(525, 900)];
    self.searchResultsPopover = [[UIPopoverController alloc] initWithContentViewController:searchResultsTableView];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self baseInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super initWithCoder:aDecoder])) {
        [self baseInit];
    }
    return self;
}

#pragma mark - SearchBar delegate methods

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    if(selectedItem == nil){
        return YES;
    }else{
        return NO;
    }
}


- (BOOL)searchBar:(UISearchBar *)bar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    NSUInteger newLength = [bar.text length] + [text length] - range.length;
    return (newLength > 50) ? NO : YES;
}

- (void)searchBar:(UISearchBar *)bar textDidChange:(NSString *)searchText {
    if(!hasSelectedItem) {
        [self searchForItems:bar];
    }
    if([[searchText trimmed] isEqualToString:@""] ){
        selectedItem = nil;
        
        [[NSNotificationCenter defaultCenter] 
         postNotificationName:@"clearedAirportSelection" 
         object:self];
        //[searchBar.inputAccessoryView setUserInteractionEnabled:YES];
    }
    hasSelectedItem = NO;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)bar {
    [self searchForItems:bar];
}

#pragma mark - Search Airports method

- (void)searchForItems:(UISearchBar *)bar {
    
    [self.searchResultsTableView.tableView reloadData];
    
    //if(!self.searchResultsPopover.isPopoverVisible && persistenceManager.recordsFound.count > 0) {
    if(!self.searchResultsPopover.isPopoverVisible) {
        CGRect popoverRect = CGRectMake(searchBar.frame.origin.x, searchBar.frame.origin.y, searchBar.frame.size.width, (searchBar.frame.size.height - 9));
        [self.searchResultsPopover presentPopoverFromRect:popoverRect inView:self permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    //return [[persistenceManager recordsFound] count];
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.font = [UIFont boldSystemFontOfSize:15];
    
    NSObject *item = [items objectAtIndex:indexPath.row];
    cell.textLabel.text = [item description];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    hasSelectedItem = YES;
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    self.searchBar.text = cell.textLabel.text;
    
    [self.searchResultsPopover dismissPopoverAnimated:YES];
    
    selectedItem = [items objectAtIndex:indexPath.row];
    [[NSNotificationCenter defaultCenter] 
     postNotificationName:sendNotificationWhenSelected 
     object:self];

    [searchBar.inputView setUserInteractionEnabled:NO];
    [searchBar resignFirstResponder];
    
}
@end
