// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to SMLChannel.m instead.

#import "_SMLChannel.h"

const struct SMLChannelAttributes SMLChannelAttributes = {
	.name = @"name",
	.ordinal = @"ordinal",
};

const struct SMLChannelRelationships SMLChannelRelationships = {
	.feeds = @"feeds",
};

const struct SMLChannelFetchedProperties SMLChannelFetchedProperties = {
};

@implementation SMLChannelID
@end

@implementation _SMLChannel

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"SMLChannel" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"SMLChannel";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"SMLChannel" inManagedObjectContext:moc_];
}

- (SMLChannelID*)objectID {
	return (SMLChannelID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"ordinalValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"ordinal"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




@dynamic name;






@dynamic ordinal;



- (int16_t)ordinalValue {
	NSNumber *result = [self ordinal];
	return [result shortValue];
}

- (void)setOrdinalValue:(int16_t)value_ {
	[self setOrdinal:[NSNumber numberWithShort:value_]];
}

- (int16_t)primitiveOrdinalValue {
	NSNumber *result = [self primitiveOrdinal];
	return [result shortValue];
}

- (void)setPrimitiveOrdinalValue:(int16_t)value_ {
	[self setPrimitiveOrdinal:[NSNumber numberWithShort:value_]];
}





@dynamic feeds;

	
- (NSMutableOrderedSet*)feedsSet {
	[self willAccessValueForKey:@"feeds"];
  
	NSMutableOrderedSet *result = (NSMutableOrderedSet*)[self mutableOrderedSetValueForKey:@"feeds"];
  
	[self didAccessValueForKey:@"feeds"];
	return result;
}
	






@end
