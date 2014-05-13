// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to NFDEventMedia.h instead.

#import <CoreData/CoreData.h>


extern const struct NFDEventMediaAttributes {
	__unsafe_unretained NSString *event_id;
	__unsafe_unretained NSString *filename;
	__unsafe_unretained NSString *groupSelector;
	__unsafe_unretained NSString *mimeType;
	__unsafe_unretained NSString *typename;
} NFDEventMediaAttributes;

extern const struct NFDEventMediaRelationships {
} NFDEventMediaRelationships;

extern const struct NFDEventMediaFetchedProperties {
} NFDEventMediaFetchedProperties;








@interface NFDEventMediaID : NSManagedObjectID {}
@end

@interface _NFDEventMedia : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (NFDEventMediaID*)objectID;





@property (nonatomic, strong) NSString* event_id;



//- (BOOL)validateEvent_id:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* filename;



//- (BOOL)validateFilename:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* groupSelector;



//- (BOOL)validateGroupSelector:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* mimeType;



//- (BOOL)validateMimeType:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* typename;



//- (BOOL)validateTypename:(id*)value_ error:(NSError**)error_;






@end

@interface _NFDEventMedia (CoreDataGeneratedAccessors)

@end

@interface _NFDEventMedia (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveEvent_id;
- (void)setPrimitiveEvent_id:(NSString*)value;




- (NSString*)primitiveFilename;
- (void)setPrimitiveFilename:(NSString*)value;




- (NSString*)primitiveGroupSelector;
- (void)setPrimitiveGroupSelector:(NSString*)value;




- (NSString*)primitiveMimeType;
- (void)setPrimitiveMimeType:(NSString*)value;




- (NSString*)primitiveTypename;
- (void)setPrimitiveTypename:(NSString*)value;




@end
