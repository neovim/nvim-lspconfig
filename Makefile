test:
	vusted ./test

lint:
	@printf "\nRunning stylua\n"
	stylua --check .
	@printf "\nRunning emmylua\n"
	emmylua_check .

.PHONY: test lint
