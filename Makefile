test:
	sh ./scripts/run_test.sh
lint:
	@echo "\nRunning luacheck\n"
	luacheck lua/* test/*
	@echo "\nRunning stylua\n"
	stylua --check .

.PHONY: test lint

