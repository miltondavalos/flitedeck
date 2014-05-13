

#import <Foundation/Foundation.h>

@interface NFDPassenger : NSObject {
    NSString *firstName;
    NSString *lastName;
    BOOL isLeadPassenger;
}
    
@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, assign) BOOL isLeadPassenger;

@end
