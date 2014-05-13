//
//  NFDGestureRecognizer.h
//  FliteDeck
//
//  Created by Chad Long on 6/20/12.
//  Copyright (c) 2012 NetJets, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^TouchesEventBlock)(NSSet * touches, UIEvent * event);

@interface NFDGestureRecognizer : UIGestureRecognizer
{
    TouchesEventBlock touchesBeganCallback;
}

@property(copy) TouchesEventBlock touchesBeganCallback;

@end
