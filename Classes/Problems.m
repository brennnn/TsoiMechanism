//
//  Problems.m
//  TsoiMechanism
//
//  Created by Brennan Maddox on 2/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Problems.h"
#import "GDataXMLNode.h"

static Problems *sharedInstance = nil;

@implementation Problems

@synthesize problemArray;

-(id) init 
{
    if (self = [super init]) 
    {
        problemArray = [[NSMutableArray alloc] init];
        problemArrayIndex = 0;
        srandom(time(NULL)); //seed
        [self load];
    }
    return self;
}

-(void) load 
{
    NSArray *xmlFiles = [[NSBundle mainBundle] pathsForResourcesOfType:@"xml" inDirectory:nil];
    for (NSString *xmlFile in xmlFiles)
    {
        [self parse:xmlFile];
    }
}

-(void) parse:(NSString *) filePath
{
    Problem *problem = [[Problem alloc] init];
    
    NSData *xmlData = [[NSMutableData alloc] initWithContentsOfFile:filePath];
    NSError *error;
    GDataXMLDocument *xml = [[GDataXMLDocument alloc] initWithData:xmlData options:0 error:&error];
    
    NSArray *moleculeNodes = [xml.rootElement elementsForName:@"Molecule"];
    for (GDataXMLElement *moleculeNode in moleculeNodes)
    {
        Molecule *molecule = [[Molecule alloc] init];
        
        NSArray *elementNodes = [moleculeNode elementsForName:@"Element"];
        for (GDataXMLElement *elementNode in elementNodes)
        {
            Element *element = [[Element alloc] init];
            
            NSArray *locationNode = [elementNode elementsForName:@"Location"];
            if (locationNode.count > 0)
            {
                GDataXMLNode *locationX = [(GDataXMLElement*) [locationNode objectAtIndex:0] attributeForName:@"x"];
                GDataXMLNode *locationY = [(GDataXMLElement*) [locationNode objectAtIndex:0] attributeForName:@"y"];
                element.location = CGPointMake(locationX.stringValue.intValue, locationY.stringValue.intValue);
            }
            
            NSArray *labelNode = [elementNode elementsForName:@"Label"];
            if (labelNode.count > 0)
            {
                GDataXMLElement *label = (GDataXMLElement*) [labelNode objectAtIndex:0];
                element.label = [[NSString alloc] initWithString:label.stringValue];
            }

            NSArray *chargeNode = [elementNode elementsForName:@"Charge"];
            if (chargeNode.count > 0)
            {
                GDataXMLElement *charge = (GDataXMLElement*) [chargeNode objectAtIndex:0];
                element.charge = charge.stringValue.intValue;
            }

            NSArray *electronsNode = [elementNode elementsForName:@"Electrons"];
            if (electronsNode.count > 0)
            {
                GDataXMLElement *electrons = (GDataXMLElement*) [electronsNode objectAtIndex:0];
                element.electrons = electrons.stringValue.intValue;
            }

            NSArray *typeNode = [elementNode elementsForName:@"Type"];
            if (typeNode.count > 0)
            {
                GDataXMLElement *type = (GDataXMLElement*) [typeNode objectAtIndex:0];
                element.type = type.stringValue.intValue;
            }  
            
            [molecule.elements setValue:element forKey:[NSString stringWithFormat:@"%i,%i", (int)element.location.x,(int)element.location.y]];
            [element release];
        }
        
        NSArray *bondNodes = [moleculeNode elementsForName:@"Bond"];
        for (GDataXMLElement *bondNode in bondNodes)
        {
            Bond *bond = [[Bond alloc] init];

            NSArray *locationANode = [bondNode elementsForName:@"LocationA"];
            if (locationANode.count > 0)
            {
                GDataXMLNode *locationAX = [(GDataXMLElement*) [locationANode objectAtIndex:0] attributeForName:@"x"];
                GDataXMLNode *locationAY = [(GDataXMLElement*) [locationANode objectAtIndex:0] attributeForName:@"y"];
                bond.locationA = CGPointMake(locationAX.stringValue.intValue, locationAY.stringValue.intValue);
            }
            
            NSArray *locationBNode = [bondNode elementsForName:@"LocationB"];
            if (locationBNode.count > 0)
            {
                GDataXMLNode *locationBX = [(GDataXMLElement*) [locationBNode objectAtIndex:0] attributeForName:@"x"];
                GDataXMLNode *locationBY = [(GDataXMLElement*) [locationBNode objectAtIndex:0] attributeForName:@"y"];
                bond.locationB = CGPointMake(locationBX.stringValue.intValue, locationBY.stringValue.intValue);
            }
            
          
            NSArray *bondOrderNode = [bondNode elementsForName:@"BondOrder"];
            if (bondOrderNode.count > 0)
            {
                GDataXMLElement *bondOrder = (GDataXMLElement*) [bondOrderNode objectAtIndex:0];
                bond.bondOrder = bondOrder.stringValue.intValue;
            }
            
            bond.location = CGPointMake((bond.locationA.x + bond.locationB.x) / 2.0f, (bond.locationA.y + bond.locationB.y) / 2.0f);
            [molecule.bonds setValue:bond forKey:[NSString stringWithFormat:@"%i,%i", (int)bond.location.x,(int)bond.location.y]];
            [bond release];
        }
        
        NSArray *arrowNodes = [moleculeNode elementsForName:@"Arrow"];
        for (GDataXMLElement *arrowNode in arrowNodes)
        {
            Arrow *arrow = [[Arrow alloc] init];
            
            NSArray *locationANode = [arrowNode elementsForName:@"LocationA"];
            if (locationANode.count > 0) {
                GDataXMLNode *locationAX = [(GDataXMLElement*) [locationANode objectAtIndex:0] attributeForName:@"x"];
                GDataXMLNode *locationAY = [(GDataXMLElement*) [locationANode objectAtIndex:0] attributeForName:@"y"];
                arrow.locationA = CGPointMake(locationAX.stringValue.intValue, locationAY.stringValue.intValue);
            }
            
            NSArray *locationBNode = [arrowNode elementsForName:@"LocationB"];
            if (locationBNode.count > 0) {
                GDataXMLNode *locationBX = [(GDataXMLElement*) [locationBNode objectAtIndex:0] attributeForName:@"x"];
                GDataXMLNode *locationBY = [(GDataXMLElement*) [locationBNode objectAtIndex:0] attributeForName:@"y"];
                arrow.locationB = CGPointMake(locationBX.stringValue.intValue, locationBY.stringValue.intValue);
            }
            
            NSArray *orderNode = [arrowNode elementsForName:@"Order"];
            if (orderNode.count > 0) {
                GDataXMLElement *order = (GDataXMLElement*) [orderNode objectAtIndex:0];
                arrow.order = order.stringValue.intValue;
            }
            
            [molecule.arrows setValue:arrow forKey:[NSString stringWithFormat:@"%i,%i,%i,%i", (int)arrow.locationA.x,(int)arrow.locationA.y,(int)arrow.locationB.x,(int)arrow.locationB.y]];
            [arrow release];
        }
        
        [problem.moleculeArray addObject:molecule];
        [molecule release];
    }
    
    [problemArray addObject:problem];
    [xml release];
    [xmlData release];
    [problem release];
}

-(void) randomize {
    if ([problemArray count] > 0) {
        int count = [problemArray count];
        for (int i = 0; i < count; i++) {
            int index = count - i;
            int n = (arc4random() % index) + i;
            [problemArray exchangeObjectAtIndex:i withObjectAtIndex:n];
        }
        for (int i = 0; i < MIN(count, MAX_PROBLEMS); i++) {
            Problem *problem = (Problem*)[problemArray objectAtIndex:i];
            int swap = arc4random() % 2;
            if (swap == 1) {
                [problem.moleculeArray exchangeObjectAtIndex:swap withObjectAtIndex:swap-1];
            }
        }

        
        problemArrayIndex = 0;
    }
}

-(Problem*) getCurrent {
    if (([problemArray count] > 0) && (problemArrayIndex < [problemArray count])) {
        return [problemArray objectAtIndex:problemArrayIndex];
    } else if (problemArrayIndex >= [problemArray count]) {
        [self randomize];
        return [self getCurrent];
    } else {
        return nil;
    }
}

-(Problem*) getNext {
    problemArrayIndex++;
    return [self getCurrent];
}


//SINGLETON CODE START
+(id) shared {
    @synchronized(self) {
        if(sharedInstance == nil)
            sharedInstance = [[super allocWithZone:NULL] init];
    }
    return sharedInstance;
}
+(id) allocWithZone:(NSZone *)zone {
    return [[self shared] retain];
}
-(id) copyWithZone:(NSZone *)zone {
    return self;
}
-(id) retain {
    return self;
}
-(unsigned) retainCount {
    return UINT_MAX;
}
-(oneway void) release {
   
}

-(id) autorelease {
    return self;
}
//SINGLETON CODE END

-(void) dealloc {
    [problemArray release];
    [super dealloc];
}

@end
