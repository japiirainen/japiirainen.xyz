PANDOC := pandoc
BROWSER_SYNC := browser-sync
WATCHEXEC := watchexec

SRC := content
OUT := public
STATIC := static
TEMPLATES := templates

PANDOC_FLAGS := \
	--standalone \
	--katex \
	--from markdown+smart+tex_math_dollars+fenced_code_attributes

PAGES := $(wildcard $(SRC)/*.md)
POSTS := $(wildcard $(SRC)/posts/*.md)

PAGE_HTML := $(patsubst $(SRC)/%.md,$(OUT)/%.html,$(PAGES))
POST_HTML := $(patsubst $(SRC)/posts/%.md,$(OUT)/%.html,$(POSTS))
ASSETS := $(patsubst $(STATIC)/%,$(OUT)/%,$(wildcard $(STATIC)/*))

.PHONY: all clean dev serve

all: $(PAGE_HTML) $(POST_HTML) $(ASSETS) $(OUT)/.nojekyll

$(OUT):
	mkdir -p $(OUT)

$(OUT)/%.html: $(SRC)/%.md $(TEMPLATES)/page.html | $(OUT)
	$(PANDOC) $(PANDOC_FLAGS) --template=$(TEMPLATES)/page.html --output=$@ $<

$(OUT)/%.html: $(SRC)/posts/%.md $(TEMPLATES)/post.html | $(OUT)
	$(PANDOC) $(PANDOC_FLAGS) --template=$(TEMPLATES)/post.html --output=$@ $<

$(OUT)/%: $(STATIC)/% | $(OUT)
	cp $< $@

$(OUT)/.nojekyll: | $(OUT)
	touch $@

serve: all
	$(BROWSER_SYNC) start --server $(OUT) --files "$(OUT)/**/*" --no-open --no-ui --port 8000

dev: all
	@sh -c '$(WATCHEXEC) --watch $(SRC) --watch $(TEMPLATES) --watch $(STATIC) --exts md,html,css --debounce 100ms -- make & pid=$$!; trap "kill $$pid 2>/dev/null || true" INT TERM EXIT; $(BROWSER_SYNC) start --server $(OUT) --files "$(OUT)/**/*" --no-open --no-ui --port 8000'

clean:
	rm -rf $(OUT)
