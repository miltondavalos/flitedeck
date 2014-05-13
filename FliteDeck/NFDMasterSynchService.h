//
//  NFDMasterSynchService.h
//  FliteDeck
//
//  Created by Jeff Bailey on 12/19/13.
//
//

#import <Foundation/Foundation.h>
#import "NFDUserManager.h"

@interface NFDMasterSynchService : NSObject

-(void) syncFromMasterForCompany:(NFDCompanySetting) companySetting;

-(BOOL) isSyncFromMasterNeeded;

@end
