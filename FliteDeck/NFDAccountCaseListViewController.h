//
//  NFDAccountCaseListViewController.h
//  FliteDeck
//
//  Created by Chad Predovich on 12/31/13.
//
//

#import <UIKit/UIKit.h>
#import "NFDCaseListViewController.h"

@interface NFDAccountCaseListViewController : NFDCaseListViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic) BOOL isLoading;

@end
