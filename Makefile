test:
	sh ./scripts/run_test.sh
lint:
	luacheck lua/* test/*
.PHONY: test lint

