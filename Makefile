.PHONY: dependencies
dependencies:
	@echo "Installing dependencies..."
	sudo apt install ansible git -y
	ansible-galaxy install -r requirements.yml
