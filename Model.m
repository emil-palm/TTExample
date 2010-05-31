//
//  Model.m
//  Example
//
//  Created by Science on 11/12/2009.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import "CJSONDeserializer.h"

@interface Model : TTURLRequestModel {
  NSDictionary *m_properties;
}
@property(nonatomic,retain) NSDictionary *properties;

@end

@implementation Model
@synthesize properties = m_properties;
- (id) init {
  if( self = [super init] ) {
		m_properties = nil;
	}
	return self;
}
//----- Model dealloc -------
- (void) dealloc {
  TT_RELEASE_SAFELY(m_properties);
	[super dealloc];
}
//----- Model initWithCoder -------
- (id) initWithCoder:(NSCoder *)aCoder {
	self = [[DCCMonitoringOverviewModel alloc] init];
  if( self != nil ) {
		m_properties = [[aCoder decodeObjectForKey:@"m_properties"] retain];
	}
	return self;
}
//----- Model encodeWithCoder -------
- (void) encodeWithCoder:(NSCoder *)aCoder {
	[aCoder encodeObject:m_properties forKey:@"m_properties"];
}

- (void) load:(TTURLRequestCachePolicy)cachePolicy more:(BOOL)more {
  if(!self.isLoading) {
    DCCURLRequest *request = [[[DCCURLRequest alloc] initWithURL:[DCCGlobal urlForType:kDCCMonitoringOverview] delegate:self] autorelease];
    DCCURLResponse *response = [[DCCURLResponse alloc] init];
    [request setResponse:response];
    request.cacheExpirationAge = TT_DEFAULT_CACHE_INVALIDATION_AGE;
    request.cachePolicy = TTURLRequestCachePolicyNone;
    TT_RELEASE_SAFELY(response);
    [request send];
  }
}

- (void) requestDidFinishLoad:(TTURLRequest *)request {
  DCCURLResponse *response = request.response;
  m_properties = [response.data copy];
  [super requestDidFinishLoad:request];
}

- (void) release {
  if([self retainCount] == 1) {
    NSLog(@"Overview model is dying");
  }
  [super release];
}

@end