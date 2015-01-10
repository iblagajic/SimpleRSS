#import "SMLChannel.h"


@interface SMLChannel ()

// Private interface goes here.

@end


@implementation SMLChannel

+ (SMLChannel*)addChannelWithName:(NSString*)name ordinal:(NSNumber*)ordinal inContext:(NSManagedObjectContext*)context {
    
    SMLChannel *channel = [SMLChannel insertInManagedObjectContext:context];
    channel.name = name;
    channel.ordinal = ordinal;
    return channel;
}

+ (NSArray*)channelsInContext:(NSManagedObjectContext*)context {
    
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"SMLChannel"];
    
    NSSortDescriptor *byOrdinal = [NSSortDescriptor sortDescriptorWithKey:@"ordinal" ascending:YES];
    fetchRequest.sortDescriptors = @[byOrdinal];
    
    NSArray *feeds = [context executeFetchRequest:fetchRequest error:nil];
    
    return feeds;
}

@end
