test:
	sh ./scripts/run_test.sh

lint:
	@printf "\nRunning luacheck\n"
	luacheck .
	@printf "\nRunning selene\n"
	selene --display-style=quiet .
	@printf "\nRunning stylua\n"
	stylua --check .

.PHONY: test lint
