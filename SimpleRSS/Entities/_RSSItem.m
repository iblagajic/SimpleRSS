// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to RSSItem.m instead.

#import "_RSSItem.h"

const struct RSSItemAttributes RSSItemAttributes = {
	.link = @"link",
	.pubDate = @"pubDate",
	.text = @"text",
	.title = @"title",
};

const struct RSSItemRelationships RSSItemRelationships = {
	.feed = @"feed",
};

const struct RSSItemFetchedProperties RSSItemFetchedProperties = {
};

@implementation RSSItemID
@end

@implementation _RSSItem

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"RSSItem" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"RSSItem";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"RSSItem" inManagedObjectContext:moc_];
}

- (RSSItemID*)objectID {
	return (RSSItemID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}




@dynamic link;






@dynamic pubDate;






@dynamic text;






@dynamic title;






@dynamic feed;

	






@end
