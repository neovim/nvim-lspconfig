test:
	sh ./scripts/run_test.sh
lint:
	@printf "\nRunning luacheck\n"
	luacheck lua/* test/*
	@printf "\nRunning stylua\n"
	stylua --check .

.PHONY: test lint

