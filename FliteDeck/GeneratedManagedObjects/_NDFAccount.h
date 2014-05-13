// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to NDFAccount.h instead.

#import <CoreData/CoreData.h>


extern const struct NDFAccountAttributes {
	__unsafe_unretained NSString *account_id;
	__unsafe_unretained NSString *account_name;
} NDFAccountAttributes;

extern const struct NDFAccountRelationships {
} NDFAccountRelationships;

extern const struct NDFAccountFetchedProperties {
} NDFAccountFetchedProperties;





@interface NDFAccountID : NSManagedObjectID {}
@end

@interface _NDFAccount : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (NDFAccountID*)objectID;





@property (nonatomic, strong) NSNumber* account_id;



@property int32_t account_idValue;
- (int32_t)account_idValue;
- (void)setAccount_idValue:(int32_t)value_;

//- (BOOL)validateAccount_id:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* account_name;



//- (BOOL)validateAccount_name:(id*)value_ error:(NSError**)error_;






@end

@interface _NDFAccount (CoreDataGeneratedAccessors)

@end

@interface _NDFAccount (CoreDataGeneratedPrimitiveAccessors)


- (NSNumber*)primitiveAccount_id;
- (void)setPrimitiveAccount_id:(NSNumber*)value;

- (int32_t)primitiveAccount_idValue;
- (void)setPrimitiveAccount_idValue:(int32_t)value_;




- (NSString*)primitiveAccount_name;
- (void)setPrimitiveAccount_name:(NSString*)value;




@end
