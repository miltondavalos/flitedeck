// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to NFDPositioningMatrix.h instead.

#import <CoreData/CoreData.h>


extern const struct NFDPositioningMatrixAttributes {
	__unsafe_unretained NSString *accost;
	__unsafe_unretained NSString *acname;
	__unsafe_unretained NSString *acpassengers;
	__unsafe_unretained NSString *acrange;
	__unsafe_unretained NSString *acshortname;
	__unsafe_unretained NSString *acspeed;
	__unsafe_unretained NSString *cabintype;
	__unsafe_unretained NSString *comparableac;
	__unsafe_unretained NSString *detailslink;
	__unsafe_unretained NSString *fleetname;
	__unsafe_unretained NSString *typename;
} NFDPositioningMatrixAttributes;

extern const struct NFDPositioningMatrixRelationships {
} NFDPositioningMatrixRelationships;

extern const struct NFDPositioningMatrixFetchedProperties {
} NFDPositioningMatrixFetchedProperties;














@interface NFDPositioningMatrixID : NSManagedObjectID {}
@end

@interface _NFDPositioningMatrix : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (NFDPositioningMatrixID*)objectID;





@property (nonatomic, strong) NSString* accost;



//- (BOOL)validateAccost:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* acname;



//- (BOOL)validateAcname:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* acpassengers;



//- (BOOL)validateAcpassengers:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* acrange;



//- (BOOL)validateAcrange:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* acshortname;



//- (BOOL)validateAcshortname:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* acspeed;



//- (BOOL)validateAcspeed:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* cabintype;



//- (BOOL)validateCabintype:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* comparableac;



//- (BOOL)validateComparableac:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* detailslink;



//- (BOOL)validateDetailslink:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* fleetname;



//- (BOOL)validateFleetname:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* typename;



//- (BOOL)validateTypename:(id*)value_ error:(NSError**)error_;






@end

@interface _NFDPositioningMatrix (CoreDataGeneratedAccessors)

@end

@interface _NFDPositioningMatrix (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveAccost;
- (void)setPrimitiveAccost:(NSString*)value;




- (NSString*)primitiveAcname;
- (void)setPrimitiveAcname:(NSString*)value;




- (NSString*)primitiveAcpassengers;
- (void)setPrimitiveAcpassengers:(NSString*)value;




- (NSString*)primitiveAcrange;
- (void)setPrimitiveAcrange:(NSString*)value;




- (NSString*)primitiveAcshortname;
- (void)setPrimitiveAcshortname:(NSString*)value;




- (NSString*)primitiveAcspeed;
- (void)setPrimitiveAcspeed:(NSString*)value;




- (NSString*)primitiveCabintype;
- (void)setPrimitiveCabintype:(NSString*)value;




- (NSString*)primitiveComparableac;
- (void)setPrimitiveComparableac:(NSString*)value;




- (NSString*)primitiveDetailslink;
- (void)setPrimitiveDetailslink:(NSString*)value;




- (NSString*)primitiveFleetname;
- (void)setPrimitiveFleetname:(NSString*)value;




- (NSString*)primitiveTypename;
- (void)setPrimitiveTypename:(NSString*)value;




@end
