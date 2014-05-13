// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to NFDCompany.h instead.

#import <CoreData/CoreData.h>


extern const struct NFDCompanyAttributes {
	__unsafe_unretained NSString *company_id;
	__unsafe_unretained NSString *competitive_analysis;
	__unsafe_unretained NSString *general_info;
	__unsafe_unretained NSString *name;
	__unsafe_unretained NSString *type;
} NFDCompanyAttributes;

extern const struct NFDCompanyRelationships {
} NFDCompanyRelationships;

extern const struct NFDCompanyFetchedProperties {
} NFDCompanyFetchedProperties;








@interface NFDCompanyID : NSManagedObjectID {}
@end

@interface _NFDCompany : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (NFDCompanyID*)objectID;





@property (nonatomic, strong) NSDecimalNumber* company_id;



//- (BOOL)validateCompany_id:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* competitive_analysis;



//- (BOOL)validateCompetitive_analysis:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* general_info;



//- (BOOL)validateGeneral_info:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* name;



//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* type;



//- (BOOL)validateType:(id*)value_ error:(NSError**)error_;






@end

@interface _NFDCompany (CoreDataGeneratedAccessors)

@end

@interface _NFDCompany (CoreDataGeneratedPrimitiveAccessors)


- (NSDecimalNumber*)primitiveCompany_id;
- (void)setPrimitiveCompany_id:(NSDecimalNumber*)value;




- (NSString*)primitiveCompetitive_analysis;
- (void)setPrimitiveCompetitive_analysis:(NSString*)value;




- (NSString*)primitiveGeneral_info;
- (void)setPrimitiveGeneral_info:(NSString*)value;




- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;




- (NSString*)primitiveType;
- (void)setPrimitiveType:(NSString*)value;




@end
