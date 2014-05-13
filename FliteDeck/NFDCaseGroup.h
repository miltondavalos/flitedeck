//
//  NFDCaseGroup.h
//  FliteDeck
//
//  Created by Chad Predovich on 12/17/13.
//
//

#import <Foundation/Foundation.h>

@interface NFDCaseGroup : NSObject

@property (strong, nonatomic) NSString *accountName;
@property (strong, nonatomic) NSString *leadPax;
@property (strong, nonatomic) NSString *tail;
@property (strong, nonatomic) NSString *departureFBO;
@property (strong, nonatomic) NSString *arrivalFBO;
@property (strong, nonatomic) NSDate *departureDate;
@property (strong, nonatomic) NSDate *arrivalDate;
@property (strong, nonatomic) NSString *legID;

@property (strong, nonatomic) NSMutableArray *cases;

- (NSString *)numberOfCasesAsString;

@end
