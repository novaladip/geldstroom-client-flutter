build_apk: $(mode)
	flutter build apk --dart-define mode=$(mode) --target-platform android-arm,android-arm64,android-x64 --split-per-abi

test:
	clear && flutter test --dart-define mode=test

test-coverage:
	clear && flutter test --coverage --dart-define mode=test

gen_code_coverage:
	genhtml coverage/lcov.info -o coverage/html

build_runner:
	flutter packages pub run build_runner build --delete-conflicting-outputs

build_runner_watch:
	flutter packages pub run build_runner watch --delete-conflicting-outputs