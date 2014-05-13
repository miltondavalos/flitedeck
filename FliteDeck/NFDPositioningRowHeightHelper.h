//
//  NFDPositioningRowHeightHelper.h
//  FliteDeck
//
//  Created by MIBEQJ0 on 4/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NFDCompany.h"
#import "NFDPositioningService.h"

@interface NFDPositioningRowHeightHelper : NSObject
+(NSNumber*) getMaxHeight : (NFDCompany *) company;
@end
