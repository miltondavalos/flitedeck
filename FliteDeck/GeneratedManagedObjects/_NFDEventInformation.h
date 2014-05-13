// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to NFDEventInformation.h instead.

#import <CoreData/CoreData.h>


extern const struct NFDEventInformationAttributes {
	__unsafe_unretained NSString *category;
	__unsafe_unretained NSString *end_date;
	__unsafe_unretained NSString *event_description;
	__unsafe_unretained NSString *event_id;
	__unsafe_unretained NSString *location;
	__unsafe_unretained NSString *media;
	__unsafe_unretained NSString *name;
	__unsafe_unretained NSString *start_date;
} NFDEventInformationAttributes;

extern const struct NFDEventInformationRelationships {
} NFDEventInformationRelationships;

extern const struct NFDEventInformationFetchedProperties {
} NFDEventInformationFetchedProperties;







@class NSObject;



@interface NFDEventInformationID : NSManagedObjectID {}
@end

@interface _NFDEventInformation : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (NFDEventInformationID*)objectID;





@property (nonatomic, strong) NSString* category;



//- (BOOL)validateCategory:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSDate* end_date;



//- (BOOL)validateEnd_date:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* event_description;



//- (BOOL)validateEvent_description:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* event_id;



//- (BOOL)validateEvent_id:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* location;



//- (BOOL)validateLocation:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) id media;



//- (BOOL)validateMedia:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* name;



//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSDate* start_date;



//- (BOOL)validateStart_date:(id*)value_ error:(NSError**)error_;






@end

@interface _NFDEventInformation (CoreDataGeneratedAccessors)

@end

@interface _NFDEventInformation (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveCategory;
- (void)setPrimitiveCategory:(NSString*)value;




- (NSDate*)primitiveEnd_date;
- (void)setPrimitiveEnd_date:(NSDate*)value;




- (NSString*)primitiveEvent_description;
- (void)setPrimitiveEvent_description:(NSString*)value;




- (NSString*)primitiveEvent_id;
- (void)setPrimitiveEvent_id:(NSString*)value;




- (NSString*)primitiveLocation;
- (void)setPrimitiveLocation:(NSString*)value;




- (id)primitiveMedia;
- (void)setPrimitiveMedia:(id)value;




- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;




- (NSDate*)primitiveStart_date;
- (void)setPrimitiveStart_date:(NSDate*)value;




@end
