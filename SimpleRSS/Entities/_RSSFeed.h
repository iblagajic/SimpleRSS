// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to RSSFeed.h instead.

#import <CoreData/CoreData.h>


extern const struct RSSFeedAttributes {
	__unsafe_unretained NSString *isInMyFeeds;
	__unsafe_unretained NSString *ordinal;
	__unsafe_unretained NSString *snippet;
	__unsafe_unretained NSString *title;
	__unsafe_unretained NSString *url;
} RSSFeedAttributes;

extern const struct RSSFeedRelationships {
	__unsafe_unretained NSString *items;
} RSSFeedRelationships;

extern const struct RSSFeedFetchedProperties {
} RSSFeedFetchedProperties;

@class RSSItem;







@interface RSSFeedID : NSManagedObjectID {}
@end

@interface _RSSFeed : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (RSSFeedID*)objectID;





@property (nonatomic, strong) NSNumber* isInMyFeeds;



@property BOOL isInMyFeedsValue;
- (BOOL)isInMyFeedsValue;
- (void)setIsInMyFeedsValue:(BOOL)value_;

//- (BOOL)validateIsInMyFeeds:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* ordinal;



@property int64_t ordinalValue;
- (int64_t)ordinalValue;
- (void)setOrdinalValue:(int64_t)value_;

//- (BOOL)validateOrdinal:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* snippet;



//- (BOOL)validateSnippet:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* title;



//- (BOOL)validateTitle:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* url;



//- (BOOL)validateUrl:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSSet *items;

- (NSMutableSet*)itemsSet;





@end

@interface _RSSFeed (CoreDataGeneratedAccessors)

- (void)addItems:(NSSet*)value_;
- (void)removeItems:(NSSet*)value_;
- (void)addItemsObject:(RSSItem*)value_;
- (void)removeItemsObject:(RSSItem*)value_;

@end

@interface _RSSFeed (CoreDataGeneratedPrimitiveAccessors)


- (NSNumber*)primitiveIsInMyFeeds;
- (void)setPrimitiveIsInMyFeeds:(NSNumber*)value;

- (BOOL)primitiveIsInMyFeedsValue;
- (void)setPrimitiveIsInMyFeedsValue:(BOOL)value_;




- (NSNumber*)primitiveOrdinal;
- (void)setPrimitiveOrdinal:(NSNumber*)value;

- (int64_t)primitiveOrdinalValue;
- (void)setPrimitiveOrdinalValue:(int64_t)value_;




- (NSString*)primitiveSnippet;
- (void)setPrimitiveSnippet:(NSString*)value;




- (NSString*)primitiveTitle;
- (void)setPrimitiveTitle:(NSString*)value;




- (NSString*)primitiveUrl;
- (void)setPrimitiveUrl:(NSString*)value;





- (NSMutableSet*)primitiveItems;
- (void)setPrimitiveItems:(NSMutableSet*)value;


@end
