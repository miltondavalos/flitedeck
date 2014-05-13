//
//  Prospect.h
//  FliteDeck
//
//  Created by MIBEQJ0 on 3/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Prospect : NSObject


@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * first_name;
@property (nonatomic, retain) NSString * last_name;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * entity;
-(void) reset;
@end
