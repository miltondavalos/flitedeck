//
//  NFDEventsMasterViewController.m
//  FliteDeck
//
//  Created by Evol Johnson on 2/16/12.
//  Copyright (c) 2012 NetJets. All rights reserved.
//

#import "NFDEventsMasterViewController.h"
#import "NFDEventsTableViewCell.h"

@implementation NFDEventsMasterViewController
@synthesize masterTableView;
@synthesize detailViewController;
@synthesize service;
@synthesize events;
@synthesize eventSearchBar;
@synthesize selectedEvent;
@synthesize pdfViewController;
@synthesize readerViewController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Events", @"Events");
        self.preferredContentSize = CGSizeMake(250, 300);
        service =[[NFDEventsService alloc] init];
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    events = [service getEvents:@""];
    
    [self updateTableViewWithNewevents];

    self.edgesForExtendedLayout = UIRectEdgeNone;
}

- (void)viewDidUnload
{
//    [[NSNotificationCenter defaultCenter] unregisterForRemoteNotifications];
    [self setMasterTableView:nil];
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}




#pragma mark - Notification Observer Methods

- (void) updateTableViewWithNewevents{
    [self.masterTableView reloadData];
    //[self.detailViewController displayMasterPopover];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [events count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NFDEventInformation *event = [events objectAtIndex:indexPath.row];
    
    static NSString *CellIdentifier = @"NFDEventsTableViewCell";
	NFDEventsTableViewCell *cell = 
    (NFDEventsTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
        NSArray* views = [[NSBundle mainBundle] loadNibNamed:@"NFDEventsTableViewCell" owner:nil options:nil];
        
        for (UIView *view in views) {
            if([view isKindOfClass:[UITableViewCell class]])
            {
                cell = (NFDEventsTableViewCell*)view;
            }
        }
	}
    
    cell.eventTitle.text = [NSString stringWithFormat:@"%@",event.name];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM/dd/yyyy"];
    [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];

    NSString *stringFromDate = [formatter stringFromDate:event.start_date];
    
    cell.eventDate.text = stringFromDate;
    cell.eventCategory.text = event.category;
    
	return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [eventSearchBar resignFirstResponder];
    NFDEventInformation *event = [events objectAtIndex:indexPath.row];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"newEventSelected" object:event];
    [readerViewController.popover dismissPopoverAnimated:YES];
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    if(selectedEvent == nil){
        return YES;
    }else{
        return NO;
    }
}


- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    NSUInteger newLength = [searchBar.text length] + [text length] - range.length;
    return (newLength > 50) ? NO : YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    events = [service getEvents:searchText];
    [self updateTableViewWithNewevents];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    events = [service getEvents:searchBar.text];
    [self updateTableViewWithNewevents];
}

@end
