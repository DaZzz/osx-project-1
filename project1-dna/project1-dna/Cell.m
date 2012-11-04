//
//  Cell.m
//  project1-dna
//
//  Created by DaZzz on 02.11.12.
//  Copyright (c) 2012 DaZzz. All rights reserved.
//

#import "Cell.h"

#define CELL_SIZE 100



@implementation NSMutableArray (Random)

-(id)randomObject {
    uint32_t rnd = arc4random_uniform((uint32_t)[self count]);
    return [self objectAtIndex: rnd];
}

@end

@implementation NSMutableArray (Shuffle)

- (void) swap: (int)i with: (int)j {
    NSObject *temp = [self objectAtIndex: i];
    [self replaceObjectAtIndex: i withObject:[self objectAtIndex: j]];
    [self replaceObjectAtIndex: j withObject: temp];
}

- (void) shuffle {
    int n = (int)[self count];
    for (int i = 0; i < n; ++i) {
        int change = i + (int)arc4random_uniform(n-i);
        [self swap: i with: change];
    }
    
}

@end

@implementation Cell

- (id)init {
    if (self = [super init]) {
        _DNA = [[NSMutableArray alloc] initWithCapacity: CELL_SIZE];
        symbols = [NSMutableArray arrayWithObjects:@"A", @"T", @"G", @"C", nil];
        for (int i = 0; i < CELL_SIZE; ++i)
            [_DNA addObject:[symbols randomObject] ];
    }
    return self;
}

- (int)hammingDistanceTo: (Cell*)aCell {
    int counter = 0;
    for (int i = 0; i < CELL_SIZE; ++i)
        if ([_DNA objectAtIndex: i] == [aCell.DNA objectAtIndex: i])
            ++counter;
    return counter;
}

- (NSString *)description {
    NSMutableString * mstr = [NSMutableString stringWithString: @""];
    for (int i = 0; i < [_DNA count]; ++i)
        [mstr appendString: [_DNA objectAtIndex: i]];
    
    return [mstr description];
}

@end

@implementation Cell (Mutator)

- (void) mutate: (int)percentage {
    NSMutableArray * indexes = [[NSMutableArray alloc] initWithCapacity:100];
    for (int i = 0; i < CELL_SIZE; ++i)
        [indexes addObject: [NSNumber numberWithInt:i]];
    [indexes shuffle];
    
    for (int i = 0; i < percentage; ++i) {
        int indexToChage = (int)[[indexes lastObject] integerValue];
        [indexes removeLastObject];
        NSMutableArray *newSymbols = [[NSMutableArray alloc] initWithArray:symbols];
        [newSymbols removeObject:[_DNA objectAtIndex:indexToChage]];
        [_DNA replaceObjectAtIndex: i withObject:[newSymbols randomObject]];
    }
}

@end