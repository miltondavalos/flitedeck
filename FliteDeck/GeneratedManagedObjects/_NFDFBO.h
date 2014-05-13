// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to NFDFBO.h instead.

#import <CoreData/CoreData.h>


extern const struct NFDFBOAttributes {
	__unsafe_unretained NSString *airportid;
	__unsafe_unretained NSString *fbo_id;
	__unsafe_unretained NSString *fbo_ranking_qty;
	__unsafe_unretained NSString *summer_operating_hour_desc;
	__unsafe_unretained NSString *sys_last_changed_ts;
	__unsafe_unretained NSString *vendor_name;
	__unsafe_unretained NSString *winter_operating_hour_desc;
} NFDFBOAttributes;

extern const struct NFDFBORelationships {
	__unsafe_unretained NSString *fboaddress;
	__unsafe_unretained NSString *fbophone;
} NFDFBORelationships;

extern const struct NFDFBOFetchedProperties {
} NFDFBOFetchedProperties;

@class NFDFBOAddress;
@class NFDFBOPhone;









@interface NFDFBOID : NSManagedObjectID {}
@end

@interface _NFDFBO : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (NFDFBOID*)objectID;





@property (nonatomic, strong) NSString* airportid;



//- (BOOL)validateAirportid:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* fbo_id;



@property int32_t fbo_idValue;
- (int32_t)fbo_idValue;
- (void)setFbo_idValue:(int32_t)value_;

//- (BOOL)validateFbo_id:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* fbo_ranking_qty;



@property int16_t fbo_ranking_qtyValue;
- (int16_t)fbo_ranking_qtyValue;
- (void)setFbo_ranking_qtyValue:(int16_t)value_;

//- (BOOL)validateFbo_ranking_qty:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* summer_operating_hour_desc;



//- (BOOL)validateSummer_operating_hour_desc:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSDate* sys_last_changed_ts;



//- (BOOL)validateSys_last_changed_ts:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* vendor_name;



//- (BOOL)validateVendor_name:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* winter_operating_hour_desc;



//- (BOOL)validateWinter_operating_hour_desc:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSSet *fboaddress;

- (NSMutableSet*)fboaddressSet;




@property (nonatomic, strong) NSSet *fbophone;

- (NSMutableSet*)fbophoneSet;





@end

@interface _NFDFBO (CoreDataGeneratedAccessors)

- (void)addFboaddress:(NSSet*)value_;
- (void)removeFboaddress:(NSSet*)value_;
- (void)addFboaddressObject:(NFDFBOAddress*)value_;
- (void)removeFboaddressObject:(NFDFBOAddress*)value_;

- (void)addFbophone:(NSSet*)value_;
- (void)removeFbophone:(NSSet*)value_;
- (void)addFbophoneObject:(NFDFBOPhone*)value_;
- (void)removeFbophoneObject:(NFDFBOPhone*)value_;

@end

@interface _NFDFBO (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveAirportid;
- (void)setPrimitiveAirportid:(NSString*)value;




- (NSNumber*)primitiveFbo_id;
- (void)setPrimitiveFbo_id:(NSNumber*)value;

- (int32_t)primitiveFbo_idValue;
- (void)setPrimitiveFbo_idValue:(int32_t)value_;




- (NSNumber*)primitiveFbo_ranking_qty;
- (void)setPrimitiveFbo_ranking_qty:(NSNumber*)value;

- (int16_t)primitiveFbo_ranking_qtyValue;
- (void)setPrimitiveFbo_ranking_qtyValue:(int16_t)value_;




- (NSString*)primitiveSummer_operating_hour_desc;
- (void)setPrimitiveSummer_operating_hour_desc:(NSString*)value;




- (NSDate*)primitiveSys_last_changed_ts;
- (void)setPrimitiveSys_last_changed_ts:(NSDate*)value;




- (NSString*)primitiveVendor_name;
- (void)setPrimitiveVendor_name:(NSString*)value;




- (NSString*)primitiveWinter_operating_hour_desc;
- (void)setPrimitiveWinter_operating_hour_desc:(NSString*)value;





- (NSMutableSet*)primitiveFboaddress;
- (void)setPrimitiveFboaddress:(NSMutableSet*)value;



- (NSMutableSet*)primitiveFbophone;
- (void)setPrimitiveFbophone:(NSMutableSet*)value;


@end
