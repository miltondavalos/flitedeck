//
//  NFDCase.h
//  FliteDeck
//
//  Created by Chad Predovich on 12/13/13.
//
//

#import <Foundation/Foundation.h>

@interface NFDCase : NSObject

@property(nonatomic, strong) NSString *requestNumber;
@property(nonatomic, strong) NSString *minutesDelayed;
@property(nonatomic, strong) NSArray *ownerImpacts;
@property(nonatomic, strong) NSString *type;
@property(nonatomic, strong) NSString *category;
@property(nonatomic, strong) NSString *details;
@property(nonatomic, strong) NSString *description;
@property(nonatomic, strong) NSString *resolution;
@property(nonatomic, strong) NSNumber *status;

- (NSMutableAttributedString *)caseTitleDisplayText;
- (NSString *)minutesDelayedDisplayText;

- (BOOL)isOpen;

@end
