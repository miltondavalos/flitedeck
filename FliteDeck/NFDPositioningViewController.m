//
//  NFDPositioningViewController.m
//  FliteDeck
//
//  Created by Evol Johnson on 2/23/12.
//  Copyright (c) 2012 NetJets. All rights reserved.
//

#import "NFDPositioningViewController.h"



@implementation NFDPositioningViewController
@synthesize theTable, competitors, manufacturers,service,heights,modalNavigationController,infoRows,header;


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    header = [[NFDPositioningHeader alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 37)];
    self.title = @"AIM";
    theTable.tableHeaderView = header;
    theTable.delegate = self;
    theTable.dataSource = self;
    heights = [[NSMutableDictionary alloc] init];
    service = [[NFDPositioningService alloc] init];

    
    UIImageView *backView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Background _Blue_Gradient_ Portrait.png"]];
    theTable.backgroundView = backView;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(displayCompanyPopup:) name:@"displayCompanyPopup" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(displayAircraftPopup:) name:@"displayAircraftPopup" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resetPopupSize) name:@"resetPopupSize" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showManufacturers:) name:@"showPACManufacturers" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showOperators:) name:@"showPACOperators" object:nil];
    
    [header showOperators:nil];
    
    self.navigationController.navigationBar.translucent = NO;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"displayCompanyPopup" object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self  name:@"displayAircraftPopup" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self  name:@"resetPopupSize" object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self  name:@"showPACManufacturers" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self  name:@"showPACOperators" object:nil];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    // Wait until now to show the nav bar rather than the caller showing the nav
    // bar which causes this view to do an odd shift downward.
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    [super viewWillAppear:animated];
    [header doLayout: CGRectMake(0, 0, theTable.frame.size.width, 37)];
    [theTable reloadData];
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

-(void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [header doLayout: CGRectMake(0, 0, theTable.frame.size.width, 37)];
    [theTable reloadData];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    //[theTable reloadData];
	return YES;
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
    return [infoRows count];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NFDCompany *company = (NFDCompany*)[infoRows objectAtIndex:indexPath.row];
    return [[NFDPositioningRowHeightHelper getMaxHeight:company] floatValue];
}




- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //static NSString *CellIdentifier = @"Cell";
    
    NFDCompany *company = (NFDCompany*)[infoRows objectAtIndex:indexPath.row];
    
    NFDPositioningCell *cell = [tableView dequeueReusableCellWithIdentifier:company.name];
    
    if (cell == nil) {
        cell = [[NFDPositioningCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:company.name];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.company = company;
        
    }
    
    [cell doLayout:tableView.frame];
    // Configure the cell...
    
    return cell;
}

-(void) displayAircraftPopup : (NSNotification*)  notification{
    NFDPositioningMatrix *aircraft = [notification object];
    
    NFDPositioningModal *modal = [[NFDPositioningModal alloc] initWithNibName:@"NFDPositioningModal" bundle:nil];
    
    modal.aircraft = aircraft;
    //if(modalNavigationController == nil){
    modalNavigationController = [[UINavigationController alloc] initWithRootViewController:modal];
    //}
    [modalNavigationController setNavigationBarHidden:NO animated:NO];
    modalNavigationController.modalPresentationStyle = UIModalPresentationFormSheet;
    
    [self presentViewController:modalNavigationController animated:YES completion:nil];
    [self resetPopupSize];
    
}

-(void) displayCompanyPopup : (NSNotification*)  notification{
    
    NFDCompany *company = [notification object];
    
    NFDPositioningModal *modal = [[NFDPositioningModal alloc] initWithNibName:@"NFDPositioningModal" bundle:nil];
    //[modal setData:company];
    modal.company = company;
    //if(modalNavigationController == nil){
    modalNavigationController = [[UINavigationController alloc] initWithRootViewController:modal];
    //}
    [modalNavigationController setNavigationBarHidden:NO animated:NO];
    modalNavigationController.modalPresentationStyle = UIModalPresentationFormSheet;
    
    [self presentViewController:modalNavigationController animated:YES completion:nil];
    [self resetPopupSize];
    
}

-(void) resetPopupSize {
    modalNavigationController.view.superview.bounds = CGRectMake(0, 0, 500, 450);
}

-(void) showOperators: (NSNotification *) notification {
    [heights removeAllObjects];
    infoRows =  [service getCompetitorNames:@""];
    [theTable reloadData];
}

-(void) showManufacturers: (NSNotification *) notification{
    [heights removeAllObjects];
    infoRows =  [service getManufacturers:@""];
    [theTable reloadData];
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }   
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }   
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
