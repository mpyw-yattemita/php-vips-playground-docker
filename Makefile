# 疑似的に make で引数渡しを可能にするマクロ
#   - 「-」から始まるオプションを各ターゲットに渡す場合，必ず前に「--」で区切りを入れる
#   - 重複したオプションや空白文字を含む場合は対応できない制約がある
ARGS = $(filter-out $@,$(MAKECMDGOALS))

# デフォルトでヘルプを表示
.DEFAULT_GOAL := help

# ヘルプ（「##」形式のコメントから自己文書化）
.PHONY: help
help: ## ヘルプを表示
	@grep -E '^[a-zA-Z][a-zA-Z._-]*:.*?## .*$$' $(MAKEFILE_LIST) \
		| sed -e 's/.*Makefile://g' \
		| awk 'BEGIN {FS = ": ## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

# セットアップ
.PHONY: setup
setup: ## セットアップ手順をすべて実行
	@$(MAKE) build
	@$(MAKE) vendor

# コンテナの基本操作
.PHONY: build up stop down exec composer run
build: ## イメージのビルド
	@docker compose build $(call ARGS)
up: ## コンテナの起動
	@docker compose up -d $(call ARGS)
stop: ## コンテナのスリープ
	@docker compose stop $(call ARGS)
down: ## コンテナの削除
	@docker compose down $(call ARGS)
exec: ## 任意コマンドを実行
	@docker compose exec php $(call ARGS)
composer: ## Composer コマンドを実行
	@$(MAKE) composer $(call ARGS)
run: ## Symfony コマンドを実行
	@$(MAKE) ./symfony-console-entrypoint.php $(call ARGS)

# vendor
.PHONY: vendor
vendor: ## vendor を準備
	@$(MAKE) up
	@$(MAKE) composer install

# 疑似引数を使用するために必要
.PHONY: %
%:
	@:
