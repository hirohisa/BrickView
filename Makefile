PROJECT = BrickView.xcodeproj

clean:
	xcodebuild \
		-project $(PROJECT) \
		clean

test:
	xcodebuild \
		-project $(PROJECT) \
		-configuration Debug \
		-sdk iphonesimulator8.1 \
		GCC_INSTRUMENT_PROGRAM_FLOW_ARCS=YES \
		GCC_GENERATE_TEST_COVERAGE_FILES=YES
