//
//  main.m
//  Anagram
//
//  Created by Sumit Jangid on 9/7/15.
//  Copyright (c) 2015 Sumit Jangid. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>
#include <time.h>

int main(int argc, char * argv[]) {
    
    
    // calculates the total time taken to find the answer in seconds
    clock_t start, end;
    start = clock();
    
    //convert argument to NSString
    NSString *pathToFile = [NSString stringWithUTF8String:argv[1]];
    
    //read file and get the contents in one NSString
    NSString* contentsOfFile =[NSString stringWithContentsOfFile:pathToFile encoding:NSUTF8StringEncoding error:nil];
    
    //Separate by new line
    NSArray* individualWords = [contentsOfFile componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    
    NSUInteger lengthOfUnsortedAnagrams = [individualWords count];
    
    NSMutableArray *sortedArray = [[NSMutableArray alloc] initWithArray:individualWords];
    
    //arrange the words and sort alphabetically
    for(int i=0;i<lengthOfUnsortedAnagrams;i++ )
    {
        NSString *unsortedString = [individualWords objectAtIndex:(i)];
        NSMutableArray *strElements = [NSMutableArray arrayWithCapacity:unsortedString.length];
        for (int i=0; i<unsortedString.length; ++i) {
            
            // Get the character from the unsorted and save the sorted string into another array
            NSString *sortedStr = [unsortedString substringWithRange:NSMakeRange(i, 1)];
            [strElements addObject:sortedStr];
        }
        [strElements sortUsingComparator:^(NSString *a, NSString *b){
            return [a compare:b];
        }];
        
        NSMutableString * result = [[NSMutableString alloc] init];
        for (NSObject * obj in strElements)
        {
            [result appendString:[obj description]];
        }
        [sortedArray replaceObjectAtIndex:i withObject:result];
    }
    
    //make datastructure to find the value in o(1)
    NSMutableDictionary *setOfAnagrams = [[NSMutableDictionary alloc] initWithCapacity:lengthOfUnsortedAnagrams];
    
    for (int i=0; i<lengthOfUnsortedAnagrams; i++)
    {
        NSString *temp = [sortedArray objectAtIndex:i];
        if(i==0)
        {
            [setOfAnagrams setObject:[[NSMutableArray alloc] initWithObjects:[NSNumber numberWithInt:i], nil] forKey:temp];
        }
        else
        {
            // find if already set of anagram exists for that word in dictionary
            if([setOfAnagrams objectForKey:temp])
            {
                NSMutableArray *refernce = setOfAnagrams[temp];
                
                [refernce addObject:[NSNumber numberWithInt:i]];
                
                [setOfAnagrams setObject:refernce forKey:temp];
            }
            else
            {
                //if not found then make the new entry in dictionary
                [setOfAnagrams setObject:[[NSMutableArray alloc] initWithObjects:[NSNumber numberWithInt:i], nil] forKey:temp];
            }
        }
    }
    
    NSLog(@"The total number of anagrams are %d", [setOfAnagrams count]);
    
    // find the largest array of anagram
    NSMutableString *largestSetOfAnagram = [[NSMutableString alloc] initWithString:@"initial"];
    int maxNumberOfAnagram=0;
    
    NSArray *sortedWords=[setOfAnagrams allKeys];
    
    for(int i=1; i<[sortedWords count]; i++)
    {
        
        if([[setOfAnagrams objectForKey:[sortedWords objectAtIndex:i]] count]>maxNumberOfAnagram)
        {
            maxNumberOfAnagram=[[setOfAnagrams objectForKey:[sortedWords objectAtIndex:i]] count];
            
            largestSetOfAnagram = [sortedWords objectAtIndex:i];
        }
    }
    
    //print out the largest set of anagrams
    NSArray *largestArray = [setOfAnagrams objectForKey:largestSetOfAnagram];
    
    NSLog(@"length of largest anagram is %d ",[largestArray count]);
    
    for (int i=0; i<[largestArray count]; i++) {
        
        NSLog(@"%@", [individualWords objectAtIndex:[[largestArray objectAtIndex:i] integerValue]]);
    }
    
    end = clock(); // calculating the total time taken to get the output in seconds
    NSLog(@"The total time to calculate the output is %lf seconds", ((double)end-start) / 1000000);
    return 0;
}
