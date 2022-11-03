ALEMBIC_SQLALCHEMY_URL ?= sqlite+pysqlite:///db.sqlite3
PYTHON_BINS ?= .venv/bin/
PYTHON_BIN ?= ${PYTHON_BINS}python

.DEFAULT_GOAL := help

help:
# @link https://github.com/marmelab/javascript-boilerplate/blob/master/makefile
	@grep -P '^[a-zA-Z/_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY: code-quality/all
code-quality/all: code-quality/black code-quality/isort   ## Run all our code quality tools

.PHONY: code-quality/black
code-quality/black: black_opts ?=
code-quality/black: ## Automated 'a la Prettier' code formatting
# @link https://black.readthedocs.io/en/stable/
	@${PYTHON_BINS}/black ${black_opts} .

.PHONY: code-quality/isort
code-quality/isort: isort_opts ?=
code-quality/isort: ## Automated Python imports formatting
	@${PYTHON_BINS}/isort --settings-file=pyproject.toml ${isort_opts} .

.PHONY: db/autogenerate-migration
db/autogenerate-migration: TITLE ?= # mandatory
db/autogenerate-migration:
	@[ "${TITLE}" ] || ( echo "! Make variable TITLE is not set"; exit 1 )
	@SQLALCHEMY_URL=${ALEMBIC_SQLALCHEMY_URL} ${PYTHON_BINS}alembic \
		revision --autogenerate -m "${TITLE}"


.PHONY: db/migrate
db/migrate: TARGET ?= head
db/migrate:
	@SQLALCHEMY_URL=${ALEMBIC_SQLALCHEMY_URL} ${PYTHON_BINS}alembic \
		upgrade ${TARGET}
