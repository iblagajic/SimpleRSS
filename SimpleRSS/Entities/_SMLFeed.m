// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to SMLFeed.m instead.

#import "_SMLFeed.h"

const struct SMLFeedAttributes SMLFeedAttributes = {
	.ordinal = @"ordinal",
	.snippet = @"snippet",
	.title = @"title",
	.url = @"url",
};

const struct SMLFeedRelationships SMLFeedRelationships = {
	.belongsTo = @"belongsTo",
	.items = @"items",
};

const struct SMLFeedFetchedProperties SMLFeedFetchedProperties = {
};

@implementation SMLFeedID
@end

@implementation _SMLFeed

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"SMLFeed" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"SMLFeed";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"SMLFeed" inManagedObjectContext:moc_];
}

- (SMLFeedID*)objectID {
	return (SMLFeedID*)[super objectID];
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




@dynamic ordinal;



- (int64_t)ordinalValue {
	NSNumber *result = [self ordinal];
	return [result longLongValue];
}

- (void)setOrdinalValue:(int64_t)value_ {
	[self setOrdinal:[NSNumber numberWithLongLong:value_]];
}

- (int64_t)primitiveOrdinalValue {
	NSNumber *result = [self primitiveOrdinal];
	return [result longLongValue];
}

- (void)setPrimitiveOrdinalValue:(int64_t)value_ {
	[self setPrimitiveOrdinal:[NSNumber numberWithLongLong:value_]];
}





@dynamic snippet;






@dynamic title;






@dynamic url;






@dynamic belongsTo;

	
- (NSMutableSet*)belongsToSet {
	[self willAccessValueForKey:@"belongsTo"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"belongsTo"];
  
	[self didAccessValueForKey:@"belongsTo"];
	return result;
}
	

@dynamic items;

	
- (NSMutableSet*)itemsSet {
	[self willAccessValueForKey:@"items"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"items"];
  
	[self didAccessValueForKey:@"items"];
	return result;
}
	






@end
