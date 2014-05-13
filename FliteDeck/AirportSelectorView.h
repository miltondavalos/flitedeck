//
//  AirportSelectorView.h
//  FlightProfile
//
//  Created by Evol Johnson on 1/9/12.
//  Copyright (c) 2012 NetJets. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchResultsTableViewController.h"
#import "NFDAirportService.h"
#import "NFDAirport.h"

#define AIRPORT_SEARCH_DID_COMPLETE_NOTIFICATION @"AirportSearchDidCompleteNotification"
#define AIRPORT_SEARCH_TEXT_NOTIFICATION_KEY @"AirportSearchTextNotificationKey"
#define AIRPORT_SEARCH_RESULTS_NOTIFICATION_KEY @"AirportSearchResultsNotificationKey"

@interface AirportSelectorView : UIView <UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate>
{
    SearchResultsTableViewController *searchResultsTableView;
    UISearchBar *airportSearchBar;
    UIPopoverController *searchResultsPopover;
    NFDAirportService *service;
    NFDAirport *selectedAirport;
    bool hasSelectedAirport;
    NSNumber *legNumber;
}

@property (nonatomic, retain) SearchResultsTableViewController *searchResultsTableView;
@property (nonatomic, retain) UISearchBar *airportSearchBar;
@property (retain, nonatomic) UIPopoverController *searchResultsPopover;
//@property (retain, nonatomic) NFDAirportService *service;
@property (retain, nonatomic) NFDAirport *selectedAirport;
@property (retain, nonatomic) NSArray *results;
@property (readwrite, copy) NSNumber *legNumber;

- (void)findAirports:(NSString*)searchText;
- (void)updateSearchResultsDisplay:(NSNotification*)notification;
- (void)setAirportFromId: (NSString *) airportid;
- (void) setAirport: (NFDAirport *) airport;
- (void)clearSelectedAirport;

@end
