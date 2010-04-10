#import <CoreFoundation/CoreFoundation.h>
#import <CoreServices/CoreServices.h>
#import <QuickLook/QuickLook.h>
#import <Foundation/Foundation.h>

/* -----------------------------------------------------------------------------
   Generate a preview for file

   This function's job is to create preview for designated file
   ----------------------------------------------------------------------------- */

OSStatus GeneratePreviewForURL(void *thisInterface, QLPreviewRequestRef preview, CFURLRef url, CFStringRef contentTypeUTI, CFDictionaryRef options)
{
	
	if (QLPreviewRequestIsCancelled(preview))
		return noErr;
	
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	
	NSDictionary *mdinfometadata = [NSDictionary dictionaryWithContentsOfURL:(NSURL *)url];
	
		
	if (!CFBooleanGetValue((CFBooleanRef)[mdinfometadata objectForKey:@"IsEncrypted"])) {
		NSDictionary *mdinfo = [NSPropertyListSerialization propertyListWithData:[mdinfometadata objectForKey:@"Metadata"]
																		 options:NSPropertyListImmutable format:nil error:nil];
		
		id xmlDAta = [NSPropertyListSerialization dataFromPropertyList:mdinfo
																format:kCFPropertyListXMLFormat_v1_0 errorDescription:nil];
		
		CFDictionaryRef properties = (CFDictionaryRef) [NSDictionary dictionary];
		
		QLPreviewRequestSetDataRepresentation(preview, (CFDataRef)xmlDAta, kUTTypeUTF8PlainText, properties);
		

	}
	
	[pool drain];
    return noErr;
}

void CancelPreviewGeneration(void* thisInterface, QLPreviewRequestRef preview)
{
    // implement only if supported
}
