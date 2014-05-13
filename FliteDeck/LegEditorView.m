//
//  LegEditorView.m
//  FliteDeck
//
//  Created by MIBEQJ0 on 3/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LegEditorView.h"
#define LEGCONTAINERWIDTH 455

@implementation LegEditorView
@synthesize legs, totalLegs,lastFrame,airports,origin,destination;
- (id) initWithCoder: (NSCoder*) coder
{
    self = [super initWithCoder:coder];
    if (self) {
        // Initialization code
        totalLegs=0;
        legs = [[NSMutableArray alloc] init];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeLeg:) name:@"removeLeg" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addLeg) name:@"addLeg" object:nil];
        
        airports = [[NSMutableArray alloc] init];
        
        lastFrame = CGRectMake(0, 0,LEGCONTAINERWIDTH,40);
    }
    return self;
}
-(BOOL) hasOriginAndDestination {
    if([legs count] < 2){
        return  NO;
    }
    OriginDestinationView *firstLeg = [legs objectAtIndex:0];
    OriginDestinationView *lastLeg = [legs lastObject];
    if(lastLeg.aselector.selectedAirport == nil || firstLeg.aselector.selectedAirport == nil){
        return  NO;
    }
    /*for(OriginDestinationView *leg in  legs){
     if(leg.aselector.selectedAirport != nil){
     
     }
     }*/
    
    return YES;
}
-(void) getAirports: (NSMutableArray *) airports_ {
    [airports_ removeAllObjects];
    if([self hasOriginAndDestination]){
        for(OriginDestinationView *leg in  legs){
            if(leg.aselector.selectedAirport != nil){
                //DLog(@"Adding airport %@ ",leg.aselector.selectedAirport.airportid);
                [airports_ addObject:leg.aselector.selectedAirport];
            }
        }
    }
}
-(void) setupAirports: (NSMutableArray *) airports_ {
    [self clearAll];
    if(airports_ == nil || airports_.count == 0 ){
        //Add origin
        [self addOrigin];      
        //Add destination;
        [self addDestination];
        return;
    }
    
    if(airports_.count == 1 ){
        //Add origin
        OriginDestinationView *leg = [self addOrigin];
        [leg setAirport:[airports_ objectAtIndex:0]];    
        //Add destination;
        [self addDestination];
        return;
    }
    
    if(airports_.count >= 2 ){
        int cont=0;
        for(NFDAirport  *a in airports_){
            //DLog(@"LegEditor %@",a);
            if(cont==0){
                OriginDestinationView *leg = [self addOrigin];
                [leg setAirport:a];
                cont++;
                continue;
            }
            
            if(cont == airports_.count-1){
                OriginDestinationView *leg = [self addDestination];
                [leg setAirport:a];
                cont++;
                continue;
            }
            LegView *leg = [self setupLeg];
            [leg setAirport:a];
            cont++;
        }
    }
}

-(void) clearAll {
    for(OriginDestinationView *leg in  legs){
        [leg removeFromSuperview];
    }
    [legs removeAllObjects];
    totalLegs = 0;
    lastFrame = CGRectMake(0, 0,LEGCONTAINERWIDTH,40);
    
}

-(OriginDestinationView*) addOrigin {
    OriginDestinationView *newLeg = [[OriginDestinationView alloc] initWithFrame:lastFrame];
    origin = newLeg;
    newLeg.position = [NSNumber numberWithInt:totalLegs];
    newLeg.tag = (200+[newLeg.position intValue]);
    [newLeg setupButtons];
    [legs addObject:newLeg];  
    [self addSubview:newLeg];
    [self layoutLegs];
    totalLegs++;
    return newLeg;
}

-(OriginDestinationView*) addDestination {
    OriginDestinationView *newLeg = [[OriginDestinationView alloc] initWithFrame:lastFrame];
    destination = newLeg;
    newLeg.position = [NSNumber numberWithInt:totalLegs];
    newLeg.tag = (200+[newLeg.position intValue]);
    newLeg.aselector.airportSearchBar.placeholder = @"Destination: Name, City or Code";
    newLeg.isDestination = YES;
    [newLeg setupButtons];
    [legs addObject:newLeg];  
    [self addSubview:newLeg];
    [self layoutLegs];
    totalLegs++;
    return newLeg;
}


-(LegView*) addLeg {
    if(legs.count < 5){
        LegView *newLeg = [[LegView alloc] initWithFrame:lastFrame];
        newLeg.position = [NSNumber numberWithInt:totalLegs];
        newLeg.tag = (200+[newLeg.position intValue]);
        newLeg.aselector.airportSearchBar.placeholder = @"Leg: Name, City or Code";
        [newLeg setupButtons];
        [legs insertObject:newLeg atIndex:legs.count- 1];
        [self addSubview:newLeg];
        [self layoutLegs];
        totalLegs++;
        return newLeg;
    }
    return nil;
}

-(LegView*) setupLeg {
    if(legs.count < 5){
        LegView *newLeg = [[LegView alloc] initWithFrame:lastFrame];
        newLeg.position = [NSNumber numberWithInt:totalLegs];
        newLeg.tag = (200+[newLeg.position intValue]);
        newLeg.aselector.airportSearchBar.placeholder = @"Leg: Name, City or Code";
        [newLeg setupButtons];
        [legs addObject:newLeg];
        [self addSubview:newLeg];
        [self layoutLegs];
        totalLegs++;
        return newLeg;
    }
    return nil;
}


-(void) removeLeg: (NSNotification*) notification{
    NSNumber *position = [notification object];
    LegView *view = (LegView*) [self viewWithTag:([position intValue]+200)];
    LegView *prev = (LegView*) [self viewWithTag:([position intValue]+199)];
    prev.addLegButton.alpha = 1.0;
    
    LegView *fwd2 = (LegView*) [self viewWithTag:([position intValue]+202)];
    LegView *fwd1 = (LegView*) [self viewWithTag:([position intValue]+201)];
   
    fwd1.addLegButton.alpha = 1.0;
    fwd2.addLegButton.alpha = 1.0;
    // prev.addLegButton.alpha = 1.0;
    //view.alpha = 0.0;   
    totalLegs--;
    [view removeFromSuperview];
    [legs removeObjectAtIndex:[position intValue]];
    [self layoutLegs];
}


-(void) layoutLegs {
    int index=0;
    float y = 0;
    CGRect newFrame;
    OriginDestinationView *prevLeg = nil;
    for(OriginDestinationView *leg in  legs){
        /*switch (index) {
         case 0:
         newFrame = CGRectMake(0, y, LEGCONTAINERWIDTH, 40);
         break;
         case 1:
         newFrame = CGRectMake(0, y, LEGCONTAINERWIDTH, 40);
         
         break;
         case 2:
         newFrame = CGRectMake(0, y, LEGCONTAINERWIDTH, 40);
         
         break;
         case 3:
         newFrame = CGRectMake(0, y, LEGCONTAINERWIDTH, 40);
         break;
         case 4:
         newFrame = CGRectMake(0, y, LEGCONTAINERWIDTH, 40);
         break;
         default:
         break;
         }*/
        
        lastFrame = newFrame = CGRectMake(0, index*48, LEGCONTAINERWIDTH, 40);;
        leg.position = [NSNumber numberWithInt:index];
        leg.tag = (200+index);
        
        
        if(index >= 1){
            [UIView animateWithDuration:0.4 animations:^{
                //leg.addLegButton.alpha = 1.0;
                leg.frame = newFrame;
            }completion:^ (BOOL finished) {
                [UIView animateWithDuration:0.3 animations:^{
                    leg.alpha = 1.0;
                    
                }];
            }];
        }else{
            
        }
        
        
        y+=48;
        index++;
        prevLeg = leg;
    }
    
    if(legs.count > 2){
        int cont=0;
        for(cont=legs.count-2; cont > 0; cont--){
            //OriginDestinationView *leg = [legs objectAtIndex:cont];
            OriginDestinationView *prevLeg = [legs objectAtIndex:cont-1];
            prevLeg.addLegButton.alpha=0;
        }
        if(legs.count == 5){
            LegView *leg = [legs objectAtIndex:legs.count-2];
            leg.addLegButton.alpha=0;
        }
    }
    
    
}

-(void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"removeLeg" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"addLeg" object:nil];
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end
