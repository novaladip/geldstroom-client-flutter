build_apk: $(mode)
	flutter build apk --dart-define mode=$(mode) --target-platform android-arm,android-arm64,android-x64 --split-per-abi

test_coverage:
	flutter test --coverage

gen_code_coverage:
	genhtml coverage/lcov.info -o coverage/html

build_runner:
	flutter packages pub run build_runner build --delete-conflicting-outputs

build_runner_watch:
	flutter packages pub run build_runner watch --delete-conflicting-outputs

gen_splash_screen:
	flutter pub run flutter_native_splash:create

gen_launcher:
	flutter pub run flutter_launcher_icons:main