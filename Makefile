-include Makefile.config

TARGET = ocamlmerlin.native

DISTNAME = ocamlmerlin-0.1
DISTFILES = configure Makefile README _tags vim emacs $(wildcard *.ml *.mli *.mly *.mll)

OCAMLBUILD=ocamlbuild -Is src,src/typing,src/parsing,src/utils
OCAMLFIND=ocamlfind

all: $(TARGET)

src/myocamlbuild_config.ml:
	@echo "Please run ./configure"
	@false

$(TARGET): src/myocamlbuild_config.ml
	$(OCAMLBUILD) -use-ocamlfind $@

.PHONY: $(TARGET) all clean distclean install uninstall

clean:
	$(OCAMLBUILD) -clean

check: $(TARGET)
	./test.sh

distclean: clean
	rm -f Makefile.config src/myocamlbuild_config.ml

install: $(TARGET)
	install -dv $(BIN_DIR)
	install -dv $(SHARE_DIR)
	install $(TARGET) $(BIN_DIR)/ocamlmerlin
	install -dv $(SHARE_DIR)/ocamlmerlin/vim
	install -dv $(SHARE_DIR)/ocamlmerlin/vimbufsync
	install -dv $(SHARE_DIR)/emacs/site-lisp
	install -m 644 emacs/merlin.el $(SHARE_DIR)/emacs/site-lisp/merlin.el
	cp -R vim/merlin/* $(SHARE_DIR)/ocamlmerlin/vim/
	cp -R vim/vimbufsync/* $(SHARE_DIR)/ocamlmerlin/vimbufsync/
	@echo >&2 
	@echo >&2 "Quick setup for VIM"
	@echo >&2 "-------------------"
	@echo >&2 "Add $(SHARE_DIR)/ocamlmerlin/vim and vimbufsync to your runtime path, e.g.:"
	@echo >&2 "  :set rtp+=$(SHARE_DIR)/ocamlmerlin/vim"
	@echo >&2 "  :set rtp+=$(SHARE_DIR)/ocamlmerlin/vimbufsync"
	@echo >&2 
	@echo >&2 "Quick setup for EMACS"
	@echo >&2 "-------------------"
	@echo >&2 "Add $(SHARE_DIR)/emacs/site-lisp to your runtime path, e.g.:"
	@echo >&2 '  (add-to-list '"'"'load-path "$(SHARE_DIR)/emacs/site-lisp")'
	@echo >&2 '  (require '"'"'merlin)'
	@echo >&2 'Then issue M-x merlin-mode in a ML buffer.'
	@echo >&2
	@echo >&2 'Take a look at https://github.com/def-lkb/merlin for more information.'
	@echo >&2

uninstall:
	rm -rf $(SHARE_DIR)/ocamlmerlin $(BIN_DIR)/ocamlmerlin $(SHARE_DIR)/emacs/site-lisp/merlin.el
