// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to NFDMasterFuelRate.h instead.

#import <CoreData/CoreData.h>
#import "NFDFuelRate.h"

extern const struct NFDMasterFuelRateAttributes {
	__unsafe_unretained NSString *companyID;
} NFDMasterFuelRateAttributes;

extern const struct NFDMasterFuelRateRelationships {
} NFDMasterFuelRateRelationships;

extern const struct NFDMasterFuelRateFetchedProperties {
} NFDMasterFuelRateFetchedProperties;




@interface NFDMasterFuelRateID : NSManagedObjectID {}
@end

@interface _NFDMasterFuelRate : NFDFuelRate {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (NFDMasterFuelRateID*)objectID;





@property (nonatomic, strong) NSString* companyID;



//- (BOOL)validateCompanyID:(id*)value_ error:(NSError**)error_;






@end

@interface _NFDMasterFuelRate (CoreDataGeneratedAccessors)

@end

@interface _NFDMasterFuelRate (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveCompanyID;
- (void)setPrimitiveCompanyID:(NSString*)value;




@end
