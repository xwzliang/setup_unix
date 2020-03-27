#!/usr/bin/env bash

dir="$(dirname "$0")"

install_package_script=$HOME/.emacs.d/emacs_install_packages.el

cat << _EOF_ >$install_package_script
(require 'package)

; find package information from following archives
(setq package-archives '(("gnu" . "http://elpa.gnu.org/packages/")
						 ("melpa" . "https://melpa.org/packages/")))
(add-to-list 'package-archives '("org" . "https://orgmode.org/elpa/") t)

; list of packages
(setq package-list
    '(
	  clues-theme                           ; An Emacs theme, which is approaching awesomeness
	  evil                                  ; The extensible vi layer for Emacs.
	  evil-collection                       ; A set of keybindings for evil-mode
	  use-package                           ; The use-package macro allows you to isolate package configuration in your .emacs file in a way that is both performance-oriented and, well, tidy. Also can auto-install package and warn instead of give error when certain package is lacking.
	  smartparens                           ; Minor mode for Emacs that deals with parens pairs and tries to be smart about it.
	  magit                                 ; Magit is an interface to the version control system Git, implemented as an Emacs package. Magit aspires to be a complete Git porcelain.
	  evil-magit                            ; This library configures Magit and Evil to play well with each other.
	  git-gutter                            ; Emacs port of GitGutter
	  evil-surround                         ; This package emulates surround.vim
	  evil-nerd-commenter                   ; Comment/uncomment lines efficiently. Like Nerd Commenter in Vim
	  neotree                               ; A Emacs tree plugin like NerdTree for Vim.
	  helm                                  ; Helm is an Emacs framework for incremental completions and narrowing selections.
	  insert-shebang                        ; Insert shebang line automatically for Emacs.
	  w3m                                   ; An Emacs interface to w3m
	  restart-emacs                         ; This is a simple package to restart Emacs for within Emacs.
	  helm-descbinds                        ; Helm Descbinds provides an interface to emacs’ describe-bindings making the currently active key bindings interactively searchable with helm.
      projectile                            ; a project interaction library for Emacs
      helm-projectile                       ; Helm integration for Projectile
      bm                                    ; This package provides visible, buffer local, bookmarks and the ability to jump forward and backward to the next bookmark.
      hydra                                 ; This is a package for GNU Emacs that can be used to tie related commands into a family of short bindings with a common prefix - a Hydra.
      iedit                                 ; Edit multiple regions simultaneously in a buffer or a region 
      evil-iedit-state                      ; Slick Evil states for iedit.
      ggtags                                ; Emacs frontend to GNU Global source code tagging system. 
      helm-gtags                            ; GNU GLOBAL helm interface
      persp-mode                            ; named perspectives(set of buffers/window configs) for emacs
      yasnippet                             ; A template system for Emacs, It allows you to type an abbreviation and automatically expand it into function templates.
      yasnippet-snippets                    ; a collection of yasnippet snippets for many languages
      helm-c-yasnippet                      ; Helm source for yasnippet
      auto-yasnippet                        ; quickly create disposable yasnippets
      company                               ; Modular in-buffer completion framework for Emacs
      helm-company                          ; Helm interface for company-mode
      expand-region                         ; Emacs extension to increase selected region by semantic units.
      ibuffer-vc                            ; Group buffers in ibuffer list by VC project
      flycheck                              ; On the fly syntax checking for GNU Emacs
      golden-ratio                          ; Automatic resizing of Emacs windows to the golden ratio
      company-c-headers                     ; Auto-completion for C/C++ headers using Company
      pdf-tools                             ; Emacs support library for PDF files.
      calfw                                 ; A calendar framework for Emacs
      calfw-org                             ; A calendar framework for Emacs org-mode
      evil-org                              ; Supplemental evil-mode keybindings to emacs org-mode
      org-brain                             ; Org-mode wiki + concept-mapping
      org-ref                               ; org-mode modules for citations, cross-references, bibliographies in org-mode and useful bibtex tools to go with it.
      anki-editor                           ; Emacs minor mode for making Anki cards with Org
      org-plus-contrib                      ; Org-mode Contributed Packages (https://orgmode.org/worg/org-contrib/)
      general                               ; Convenience wrappers for keybindings
      auto-package-update                   ; Automatically update Emacs packages. 
      forge                                 ; Work with Git forges from the comfort of Magit
      helm-swoop                            ; helm-swoop allows to show interactively lines (in one or multiple buffers) that match a pattern in another (helm) buffer
      helm-ag                               ; The silver searcher with helm interface
      macrostep                             ; interactive macro-expander for Emacs
      evil-exchange                         ; Port of vim-exchange
      evil-replace-with-register			; Port of vim ReplaceWithRegister
      evil-visualstar                       ; Port of one of the many visual-star plugins for Vim. Start a * or # search from the visual selection
      evil-lion                             ; Evil align operator
      evil-numbers                          ; Increment and decrement numbers in Emacs
      evil-args                             ; Motions and text objects for delimited arguments in Evil
      evil-indent-plus                      ; Better indent textobjects for evil
      evil-visual-mark-mode                 ; Display evil marks on buffer
      anzu                                  ; Emacs port of anzu.vim. anzu.el provides a minor mode which displays current match and total matches information in the mode-line 
      evil-anzu                             ; anzu for Evil
      evil-mc                               ; Multiple cursors implementation for evil-mode
	  ))

; activate all the packages
(package-initialize)

; fetch the list of packages available
(unless package-archive-contents
  (package-refresh-contents))

; do package-refresh-contents according to the value of argument 0
(if (string= "refresh" (elt argv 0))
  (package-refresh-contents))

; install the missing packages
(dolist (package package-list)
  (unless (package-installed-p package)
    (package-install package)))

; Install Bookmark+ from the EmacsWiki
(let ((bookmarkplus-dir "~/.emacs.d/custom/bookmark-plus/")
	(emacswiki-base "https://www.emacswiki.org/emacs/download/")
	(bookmark-files '("bookmark+.el" "bookmark+-mac.el" "bookmark+-bmu.el" "bookmark+-key.el" "bookmark+-lit.el" "bookmark+-1.el")))
	(require 'url)
	(add-to-list 'load-path bookmarkplus-dir)
	(make-directory bookmarkplus-dir t)
	(mapcar (lambda (arg)
			(let ((local-file (concat bookmarkplus-dir arg)))
				(unless (file-exists-p local-file)
				(url-copy-file (concat emacswiki-base arg) local-file t))))
			bookmark-files)
	(byte-recompile-directory bookmarkplus-dir 0))

;; Delete anki-editor elc file if existed, this file will cause note id cannot be added.
(let ((filename (concat (concat (expand-file-name "~/.emacs.d/elpa/") (car (directory-files (expand-file-name "~/.emacs.d/elpa/") nil "^anki-editor"))) "/anki-editor.elc")))
	(if (file-exists-p filename)
		(delete-file filename)))

_EOF_

emacs --script $install_package_script || emacs --script $install_package_script refresh
