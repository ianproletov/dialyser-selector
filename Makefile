install:
	npm ci
publish:
	npm publish --dry-run
lint:
	npx eslint .
start:
	src/bin/start.js
