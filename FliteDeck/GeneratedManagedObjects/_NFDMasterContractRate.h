// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to NFDMasterContractRate.h instead.

#import <CoreData/CoreData.h>
#import "NFDContractRate.h"

extern const struct NFDMasterContractRateAttributes {
	__unsafe_unretained NSString *companyID;
} NFDMasterContractRateAttributes;

extern const struct NFDMasterContractRateRelationships {
} NFDMasterContractRateRelationships;

extern const struct NFDMasterContractRateFetchedProperties {
} NFDMasterContractRateFetchedProperties;




@interface NFDMasterContractRateID : NSManagedObjectID {}
@end

@interface _NFDMasterContractRate : NFDContractRate {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (NFDMasterContractRateID*)objectID;





@property (nonatomic, strong) NSString* companyID;



//- (BOOL)validateCompanyID:(id*)value_ error:(NSError**)error_;






@end

@interface _NFDMasterContractRate (CoreDataGeneratedAccessors)

@end

@interface _NFDMasterContractRate (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveCompanyID;
- (void)setPrimitiveCompanyID:(NSString*)value;




@end
