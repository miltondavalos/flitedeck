// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to NFDFBOPhone.h instead.

#import <CoreData/CoreData.h>


extern const struct NFDFBOPhoneAttributes {
	__unsafe_unretained NSString *area_code_txt;
	__unsafe_unretained NSString *country_code_txt;
	__unsafe_unretained NSString *fbo_id;
	__unsafe_unretained NSString *sys_last_changed_ts;
	__unsafe_unretained NSString *telephone_id;
	__unsafe_unretained NSString *telephone_nbr_txt;
} NFDFBOPhoneAttributes;

extern const struct NFDFBOPhoneRelationships {
	__unsafe_unretained NSString *fboPhoneParent;
} NFDFBOPhoneRelationships;

extern const struct NFDFBOPhoneFetchedProperties {
} NFDFBOPhoneFetchedProperties;

@class NFDFBO;








@interface NFDFBOPhoneID : NSManagedObjectID {}
@end

@interface _NFDFBOPhone : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (NFDFBOPhoneID*)objectID;





@property (nonatomic, strong) NSString* area_code_txt;



//- (BOOL)validateArea_code_txt:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* country_code_txt;



//- (BOOL)validateCountry_code_txt:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* fbo_id;



@property int32_t fbo_idValue;
- (int32_t)fbo_idValue;
- (void)setFbo_idValue:(int32_t)value_;

//- (BOOL)validateFbo_id:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSDate* sys_last_changed_ts;



//- (BOOL)validateSys_last_changed_ts:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* telephone_id;



@property int32_t telephone_idValue;
- (int32_t)telephone_idValue;
- (void)setTelephone_idValue:(int32_t)value_;

//- (BOOL)validateTelephone_id:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* telephone_nbr_txt;



//- (BOOL)validateTelephone_nbr_txt:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NFDFBO *fboPhoneParent;

//- (BOOL)validateFboPhoneParent:(id*)value_ error:(NSError**)error_;





@end

@interface _NFDFBOPhone (CoreDataGeneratedAccessors)

@end

@interface _NFDFBOPhone (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveArea_code_txt;
- (void)setPrimitiveArea_code_txt:(NSString*)value;




- (NSString*)primitiveCountry_code_txt;
- (void)setPrimitiveCountry_code_txt:(NSString*)value;




- (NSNumber*)primitiveFbo_id;
- (void)setPrimitiveFbo_id:(NSNumber*)value;

- (int32_t)primitiveFbo_idValue;
- (void)setPrimitiveFbo_idValue:(int32_t)value_;




- (NSDate*)primitiveSys_last_changed_ts;
- (void)setPrimitiveSys_last_changed_ts:(NSDate*)value;




- (NSNumber*)primitiveTelephone_id;
- (void)setPrimitiveTelephone_id:(NSNumber*)value;

- (int32_t)primitiveTelephone_idValue;
- (void)setPrimitiveTelephone_idValue:(int32_t)value_;




- (NSString*)primitiveTelephone_nbr_txt;
- (void)setPrimitiveTelephone_nbr_txt:(NSString*)value;





- (NFDFBO*)primitiveFboPhoneParent;
- (void)setPrimitiveFboPhoneParent:(NFDFBO*)value;


@end
