#import "_SMLChannel.h"

@interface SMLChannel : _SMLChannel {}

+ (void)addChannelWithName:(NSString*)name ordinal:(NSNumber*)ordinal inContext:(NSManagedObjectContext*)context;
+ (NSArray*)channelsInContext:(NSManagedObjectContext*)context;

@end
