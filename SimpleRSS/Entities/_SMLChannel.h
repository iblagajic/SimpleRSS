// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to SMLChannel.h instead.

#import <CoreData/CoreData.h>


extern const struct SMLChannelAttributes {
	__unsafe_unretained NSString *name;
	__unsafe_unretained NSString *ordinal;
} SMLChannelAttributes;

extern const struct SMLChannelRelationships {
	__unsafe_unretained NSString *feeds;
} SMLChannelRelationships;

extern const struct SMLChannelFetchedProperties {
} SMLChannelFetchedProperties;

@class SMLFeed;




@interface SMLChannelID : NSManagedObjectID {}
@end

@interface _SMLChannel : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (SMLChannelID*)objectID;





@property (nonatomic, strong) NSString* name;



//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* ordinal;



@property int16_t ordinalValue;
- (int16_t)ordinalValue;
- (void)setOrdinalValue:(int16_t)value_;

//- (BOOL)validateOrdinal:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSOrderedSet *feeds;

- (NSMutableOrderedSet*)feedsSet;





@end

@interface _SMLChannel (CoreDataGeneratedAccessors)

- (void)addFeeds:(NSOrderedSet*)value_;
- (void)removeFeeds:(NSOrderedSet*)value_;
- (void)addFeedsObject:(SMLFeed*)value_;
- (void)removeFeedsObject:(SMLFeed*)value_;

@end

@interface _SMLChannel (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;




- (NSNumber*)primitiveOrdinal;
- (void)setPrimitiveOrdinal:(NSNumber*)value;

- (int16_t)primitiveOrdinalValue;
- (void)setPrimitiveOrdinalValue:(int16_t)value_;





- (NSMutableOrderedSet*)primitiveFeeds;
- (void)setPrimitiveFeeds:(NSMutableOrderedSet*)value;


@end
