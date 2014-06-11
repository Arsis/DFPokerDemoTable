// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to DFPlayer.h instead.

#import <CoreData/CoreData.h>


extern const struct DFPlayerAttributes {
	__unsafe_unretained NSString *avatarPath;
	__unsafe_unretained NSString *firstName;
	__unsafe_unretained NSString *lastNamae;
} DFPlayerAttributes;

extern const struct DFPlayerRelationships {
} DFPlayerRelationships;

extern const struct DFPlayerFetchedProperties {
} DFPlayerFetchedProperties;






@interface DFPlayerID : NSManagedObjectID {}
@end

@interface _DFPlayer : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (DFPlayerID*)objectID;





@property (nonatomic, strong) NSString* avatarPath;



//- (BOOL)validateAvatarPath:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* firstName;



//- (BOOL)validateFirstName:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* lastNamae;



//- (BOOL)validateLastNamae:(id*)value_ error:(NSError**)error_;






@end

@interface _DFPlayer (CoreDataGeneratedAccessors)

@end

@interface _DFPlayer (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveAvatarPath;
- (void)setPrimitiveAvatarPath:(NSString*)value;




- (NSString*)primitiveFirstName;
- (void)setPrimitiveFirstName:(NSString*)value;




- (NSString*)primitiveLastNamae;
- (void)setPrimitiveLastNamae:(NSString*)value;




@end
