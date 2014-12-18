// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to SMLFeed.h instead.

#import <CoreData/CoreData.h>


extern const struct SMLFeedAttributes {
	__unsafe_unretained NSString *snippet;
	__unsafe_unretained NSString *title;
	__unsafe_unretained NSString *url;
} SMLFeedAttributes;

extern const struct SMLFeedRelationships {
	__unsafe_unretained NSString *channels;
	__unsafe_unretained NSString *items;
} SMLFeedRelationships;

extern const struct SMLFeedFetchedProperties {
} SMLFeedFetchedProperties;

@class SMLChannel;
@class SMLItem;





@interface SMLFeedID : NSManagedObjectID {}
@end

@interface _SMLFeed : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (SMLFeedID*)objectID;





@property (nonatomic, strong) NSString* snippet;



//- (BOOL)validateSnippet:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* title;



//- (BOOL)validateTitle:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* url;



//- (BOOL)validateUrl:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSSet *channels;

- (NSMutableSet*)channelsSet;




@property (nonatomic, strong) NSSet *items;

- (NSMutableSet*)itemsSet;





@end

@interface _SMLFeed (CoreDataGeneratedAccessors)

- (void)addChannels:(NSSet*)value_;
- (void)removeChannels:(NSSet*)value_;
- (void)addChannelsObject:(SMLChannel*)value_;
- (void)removeChannelsObject:(SMLChannel*)value_;

- (void)addItems:(NSSet*)value_;
- (void)removeItems:(NSSet*)value_;
- (void)addItemsObject:(SMLItem*)value_;
- (void)removeItemsObject:(SMLItem*)value_;

@end

@interface _SMLFeed (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveSnippet;
- (void)setPrimitiveSnippet:(NSString*)value;




- (NSString*)primitiveTitle;
- (void)setPrimitiveTitle:(NSString*)value;




- (NSString*)primitiveUrl;
- (void)setPrimitiveUrl:(NSString*)value;





- (NSMutableSet*)primitiveChannels;
- (void)setPrimitiveChannels:(NSMutableSet*)value;



- (NSMutableSet*)primitiveItems;
- (void)setPrimitiveItems:(NSMutableSet*)value;


@end
