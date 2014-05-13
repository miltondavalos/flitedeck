// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to NFDFBOAddress.h instead.

#import <CoreData/CoreData.h>


extern const struct NFDFBOAddressAttributes {
	__unsafe_unretained NSString *address_id;
	__unsafe_unretained NSString *address_line1_txt;
	__unsafe_unretained NSString *address_line2_txt;
	__unsafe_unretained NSString *address_line3_txt;
	__unsafe_unretained NSString *address_line4_txt;
	__unsafe_unretained NSString *address_line5_txt;
	__unsafe_unretained NSString *city_name;
	__unsafe_unretained NSString *country_cd;
	__unsafe_unretained NSString *fbo_id;
	__unsafe_unretained NSString *postal_cd;
	__unsafe_unretained NSString *state_province_name;
	__unsafe_unretained NSString *sys_last_changed_ts;
} NFDFBOAddressAttributes;

extern const struct NFDFBOAddressRelationships {
	__unsafe_unretained NSString *fboAddressParent;
} NFDFBOAddressRelationships;

extern const struct NFDFBOAddressFetchedProperties {
} NFDFBOAddressFetchedProperties;

@class NFDFBO;














@interface NFDFBOAddressID : NSManagedObjectID {}
@end

@interface _NFDFBOAddress : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (NFDFBOAddressID*)objectID;





@property (nonatomic, strong) NSNumber* address_id;



@property int32_t address_idValue;
- (int32_t)address_idValue;
- (void)setAddress_idValue:(int32_t)value_;

//- (BOOL)validateAddress_id:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* address_line1_txt;



//- (BOOL)validateAddress_line1_txt:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* address_line2_txt;



//- (BOOL)validateAddress_line2_txt:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* address_line3_txt;



//- (BOOL)validateAddress_line3_txt:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* address_line4_txt;



//- (BOOL)validateAddress_line4_txt:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* address_line5_txt;



//- (BOOL)validateAddress_line5_txt:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* city_name;



//- (BOOL)validateCity_name:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* country_cd;



//- (BOOL)validateCountry_cd:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* fbo_id;



@property int32_t fbo_idValue;
- (int32_t)fbo_idValue;
- (void)setFbo_idValue:(int32_t)value_;

//- (BOOL)validateFbo_id:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* postal_cd;



//- (BOOL)validatePostal_cd:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* state_province_name;



//- (BOOL)validateState_province_name:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSDate* sys_last_changed_ts;



//- (BOOL)validateSys_last_changed_ts:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NFDFBO *fboAddressParent;

//- (BOOL)validateFboAddressParent:(id*)value_ error:(NSError**)error_;





@end

@interface _NFDFBOAddress (CoreDataGeneratedAccessors)

@end

@interface _NFDFBOAddress (CoreDataGeneratedPrimitiveAccessors)


- (NSNumber*)primitiveAddress_id;
- (void)setPrimitiveAddress_id:(NSNumber*)value;

- (int32_t)primitiveAddress_idValue;
- (void)setPrimitiveAddress_idValue:(int32_t)value_;




- (NSString*)primitiveAddress_line1_txt;
- (void)setPrimitiveAddress_line1_txt:(NSString*)value;




- (NSString*)primitiveAddress_line2_txt;
- (void)setPrimitiveAddress_line2_txt:(NSString*)value;




- (NSString*)primitiveAddress_line3_txt;
- (void)setPrimitiveAddress_line3_txt:(NSString*)value;




- (NSString*)primitiveAddress_line4_txt;
- (void)setPrimitiveAddress_line4_txt:(NSString*)value;




- (NSString*)primitiveAddress_line5_txt;
- (void)setPrimitiveAddress_line5_txt:(NSString*)value;




- (NSString*)primitiveCity_name;
- (void)setPrimitiveCity_name:(NSString*)value;




- (NSString*)primitiveCountry_cd;
- (void)setPrimitiveCountry_cd:(NSString*)value;




- (NSNumber*)primitiveFbo_id;
- (void)setPrimitiveFbo_id:(NSNumber*)value;

- (int32_t)primitiveFbo_idValue;
- (void)setPrimitiveFbo_idValue:(int32_t)value_;




- (NSString*)primitivePostal_cd;
- (void)setPrimitivePostal_cd:(NSString*)value;




- (NSString*)primitiveState_province_name;
- (void)setPrimitiveState_province_name:(NSString*)value;




- (NSDate*)primitiveSys_last_changed_ts;
- (void)setPrimitiveSys_last_changed_ts:(NSDate*)value;





- (NFDFBO*)primitiveFboAddressParent;
- (void)setPrimitiveFboAddressParent:(NFDFBO*)value;


@end
