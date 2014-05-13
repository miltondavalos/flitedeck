//
//  NCLAnalyticsTableViewController.m
//  NCLFramework
//
//  Created by Chad Long on 11/11/13.
//  Copyright (c) 2013 NetJets, Inc. All rights reserved.
//

#import "NCLAnalyticsTableViewController.h"
#import "NCLAnalyticsPersistenceManager.h"
#import "NCLAnalyticsTableViewCell.h"

#import "Event.h"

@interface NCLAnalyticsTableViewController ()

@property (nonatomic, strong) NSMutableArray *viewConstraints;
@property (nonatomic, strong) NSFetchedResultsController *fetchController;

@end

@implementation NCLAnalyticsTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    
    if (self)
    {
        [self.tableView registerClass:[NCLAnalyticsTableViewCell class] forCellReuseIdentifier:@"NCLAnalyticsTableViewCell"];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.viewConstraints = [NSMutableArray new];
    self.tableView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
    [self.tableView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    NSError *error = nil;
    
	if (![[self fetchController] performFetch:&error])
    {
		[NCLErrorPresenter presentError:error];
	}
}

#pragma mark - fetch results controller updates

- (NSFetchedResultsController *)fetchController
{
    if (_fetchController != nil)
    {
        return _fetchController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Event" inManagedObjectContext:[[NCLAnalyticsPersistenceManager sharedInstance] mainMOC]];
    [fetchRequest setEntity:entity];
    [fetchRequest setFetchBatchSize:20];
    
    NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"createdTS" ascending:NO];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];
    
    _fetchController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                           managedObjectContext:[[NCLAnalyticsPersistenceManager sharedInstance] mainMOC]
                                                             sectionNameKeyPath:nil
                                                                      cacheName:@"Root"];
    _fetchController.delegate = self;
    
    return _fetchController;
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    // The fetch controller is about to start sending change notifications, so prepare the table view for updates.
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath
{
    UITableView *tableView = self.tableView;
    
    switch(type)
    {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            //            [tableView cellForRowAtIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id )sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    switch(type)
    {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    // The fetch controller has sent all current change notifications, so tell the table view to process all updates.
    [self.tableView endUpdates];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 72;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 72;
//    NCLAnalyticsTableViewCell *cell = (NCLAnalyticsTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"NCLAnalyticsTableViewCell"];
//    
//    Event *event = [self.fetchController objectAtIndexPath:indexPath];
//    [self prepareCell:cell forEvent:event];
//    
//    [cell.contentView setNeedsLayout];
//    [cell.contentView layoutIfNeeded];
//    CGFloat height = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
//    
//    return height;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id  sectionInfo = [[self.fetchController sections] objectAtIndex:section];
    
    INFOLog(@"number of analytics records available for view: %d", [sectionInfo numberOfObjects]);
    
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NCLAnalyticsTableViewCell *cell = (NCLAnalyticsTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"NCLAnalyticsTableViewCell"];
    
    Event *event = [self.fetchController objectAtIndexPath:indexPath];
    [self prepareCell:cell forEvent:event];
    
    return cell;
}

- (void)prepareCell:(NCLAnalyticsTableViewCell*)cell forEvent:(Event*)event
{
    static NSDateFormatter *formatter;
    static dispatch_once_t pred;
    
    dispatch_once
    (&pred, ^
     {
         formatter = [[NSDateFormatter alloc] init];
         [formatter setTimeStyle:NSDateFormatterMediumStyle];
     });
    
    cell.createdLabel.text = [formatter stringFromDate:event.createdTS];
    cell.actionLabel.text = [NSString stringWithFormat:@"%@-%@", event.component, event.action];
    cell.elapsedTimeLabel.text = [event.elapsedTime stringValue];
    cell.valueLabel.text = event.value;
    
    if (event.errorCode &&
        event.errorCode.integerValue > 0)
    {
        cell.errorLabel.text = [event.errorCode stringValue];
    }
    else
    {
        cell.errorLabel.text = @"";
    }
}

@end
