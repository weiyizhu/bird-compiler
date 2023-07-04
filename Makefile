.PHONY: setup
setup: 
	@chmod +x setup.sh
	@./setup.sh

.PHONY: clean
clean:
	@rm -rf logs
	@rm -rf output