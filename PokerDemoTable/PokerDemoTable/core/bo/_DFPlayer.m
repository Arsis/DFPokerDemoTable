// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to DFPlayer.m instead.

#import "_DFPlayer.h"

const struct DFPlayerAttributes DFPlayerAttributes = {
	.avatarPath = @"avatarPath",
	.firstName = @"firstName",
	.lastNamae = @"lastNamae",
};

const struct DFPlayerRelationships DFPlayerRelationships = {
};

const struct DFPlayerFetchedProperties DFPlayerFetchedProperties = {
};

@implementation DFPlayerID
@end

@implementation _DFPlayer

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"DFPlayer" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"DFPlayer";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"DFPlayer" inManagedObjectContext:moc_];
}

- (DFPlayerID*)objectID {
	return (DFPlayerID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}




@dynamic avatarPath;






@dynamic firstName;






@dynamic lastNamae;











@end
