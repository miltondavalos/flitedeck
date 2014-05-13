// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to NFDAircraftInventory.h instead.

#import <CoreData/CoreData.h>


extern const struct NFDAircraftInventoryAttributes {
	__unsafe_unretained NSString *anticipated_delivery_date;
	__unsafe_unretained NSString *contracts_until_date;
	__unsafe_unretained NSString *legal_name;
	__unsafe_unretained NSString *sales_value;
	__unsafe_unretained NSString *serial;
	__unsafe_unretained NSString *share_immediately_available;
	__unsafe_unretained NSString *tail;
	__unsafe_unretained NSString *type;
	__unsafe_unretained NSString *year;
} NFDAircraftInventoryAttributes;

extern const struct NFDAircraftInventoryRelationships {
} NFDAircraftInventoryRelationships;

extern const struct NFDAircraftInventoryFetchedProperties {
} NFDAircraftInventoryFetchedProperties;












@interface NFDAircraftInventoryID : NSManagedObjectID {}
@end

@interface _NFDAircraftInventory : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (NFDAircraftInventoryID*)objectID;





@property (nonatomic, strong) NSDate* anticipated_delivery_date;



//- (BOOL)validateAnticipated_delivery_date:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSDate* contracts_until_date;



//- (BOOL)validateContracts_until_date:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* legal_name;



//- (BOOL)validateLegal_name:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* sales_value;



//- (BOOL)validateSales_value:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* serial;



//- (BOOL)validateSerial:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* share_immediately_available;



//- (BOOL)validateShare_immediately_available:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* tail;



//- (BOOL)validateTail:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* type;



//- (BOOL)validateType:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* year;



//- (BOOL)validateYear:(id*)value_ error:(NSError**)error_;






@end

@interface _NFDAircraftInventory (CoreDataGeneratedAccessors)

@end

@interface _NFDAircraftInventory (CoreDataGeneratedPrimitiveAccessors)


- (NSDate*)primitiveAnticipated_delivery_date;
- (void)setPrimitiveAnticipated_delivery_date:(NSDate*)value;




- (NSDate*)primitiveContracts_until_date;
- (void)setPrimitiveContracts_until_date:(NSDate*)value;




- (NSString*)primitiveLegal_name;
- (void)setPrimitiveLegal_name:(NSString*)value;




- (NSString*)primitiveSales_value;
- (void)setPrimitiveSales_value:(NSString*)value;




- (NSString*)primitiveSerial;
- (void)setPrimitiveSerial:(NSString*)value;




- (NSString*)primitiveShare_immediately_available;
- (void)setPrimitiveShare_immediately_available:(NSString*)value;




- (NSString*)primitiveTail;
- (void)setPrimitiveTail:(NSString*)value;




- (NSString*)primitiveType;
- (void)setPrimitiveType:(NSString*)value;




- (NSString*)primitiveYear;
- (void)setPrimitiveYear:(NSString*)value;




@end
