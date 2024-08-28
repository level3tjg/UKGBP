#import <UIKit/UIKit.h>

static NSArray <NSString *>*restrictedPaths;
static NSArray <NSString *>*restrictedSchemes;

%hook NSFileManager
- (BOOL)fileExistsAtPath:(NSString *)path {
	if ([restrictedPaths containsObject:path])
		return NO;
	return %orig;
}
- (BOOL)writeToFile:(NSString *)path atomically:(BOOL)useAuxiliaryFile encoding:(NSStringEncoding)enc error:(NSError **)error {
	if ([restrictedPaths containsObject:path]) {
		*error = [NSError errorWithDomain:@"UKGBP" code:NSFileWriteNoPermissionError userInfo:nil];
		return NO;
	}
	return %orig;
}
%end

%hook UIApplication
- (BOOL)canOpenURL:(NSURL *)url {
	if ([restrictedSchemes containsObject:url.scheme])
		return NO;
	return %orig;
}
%end

%hookf(FILE *, fopen, const char *filename, const char *mode) {
	if ([restrictedPaths containsObject:@(filename)])
		return NULL;
	return %orig;
}

%ctor {
	restrictedPaths = @[
		@"/Applications/Cydia.app",
		@"cycript",
		@"bin/ssh",
		@"/bin/bash",
		@"/etc/apt",
		@"/Applications/blackra1n.app",
		@"/Applications/FakeCarrier.app",
		@"/Applications/Icy.app",
		@"/Applications/IntelliScreen.app",
		@"/Applications/MxTube.app",
		@"/Applications/RockApp.app",
		@"/Applications/SBSettings.app",
		@"/Applications/WinterBoard.app",
		@"/Library/MobileSubstrate",
		@"/var/lib/apt",
		@"/var/lib/cydia",
		@"/var/mobile/Library/SBSettings/Themes",
		@"/var/stash",
		@"/var/tmp/cydia.log",
		@"/System/Library/LaunchDaemons/com.ikey.bbot.plist",
		@"/System/Library/LaunchDaemons/com.saurik.Cydia.Startup.plist",
		@"/usr/libexec/sftp-server",
		@"/usr/sbin/sshd_config",
		@"/usr/sbin/frida-server",
		@"/var/cache/apt",
		@"/bin/sh",
		@"/Library/PreferenceBundles",
		@"/Library/PreferenceLoader",
		@"/private/testwfd.txt"
	];
	restrictedSchemes = @[
		@"cydia",
	];
}