test:
	sh ./scripts/run_test.sh

lint:
	@printf "\nRunning luacheck\n"
	luacheck lua/* test/*
	@printf "\nRunning selene\n"
	selene --display-style=quiet .
	@printf "\nRunning stylua\n"
	stylua --check .

.PHONY: test lint

luarocks_upload:
	bash ./scripts/luarocks-upload.sh

test_luarocks_install:
	bash ./scripts/test-luarocks-install.sh
