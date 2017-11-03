;;;; initialization for GNU Emacs.

(require 'package)
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/"))
(package-initialize)


;; Configuration mostly via use-package: https://github.com/jwiegley/use-package
(use-package cl)

(use-package bm
  :load-path "site-lisp"
  :bind (("<f2>"   . bm-next)
         ("S-<f2>" . bm-previous)
         ("C-<f2>" . bm-toggle)
         ("<M-f2>" . bm-show-all))
  :config
  ;; (setq bm-cycle-all-buffers t)                ; Allow cross-buffer 'next'
  (setq bm-highlight-style 'bm-highlight-line-and-fringe))

(use-package windmove
  :config (windmove-default-keybindings))      ; S-up, S-down, S-left, S-right move between windows

(use-package org
  :config
  (add-hook 'org-shiftup-final-hook    #'windmove-up)
  (add-hook 'org-shiftleft-final-hook  #'windmove-left)
  (add-hook 'org-shiftdown-final-hook  #'windmove-down)
  (add-hook 'org-shiftright-final-hook #'windmove-right))

(use-package multiple-cursors
  :bind (("C-S-c C-S-c" . mc/edit-lines)
         ("C-S-<mouse-1>" . mc/add-cursor-on-click)))

(use-package magit
  :bind (("C-x g" . magit-status)))

(use-package linum) ;; line numbers

(use-package dired  ;; dired modifications
  :config (setq ls-lisp-dired-ignore-case t)
  :bind (:map dired-mode-map
              ("<DEL>" . dired-up-directory)))

(use-package whitespace
  :bind (("C-<f1>" . whitespace-mode))
  :config (setq whitespace-style '(spaces tabs newline space-mark tab-mark newline-mark)))

(use-package ido
  :config (ido-mode t))

(use-package flx-ido
  :config
  (flx-ido-mode 1)
  (setq ido-enable-flex-matching t)
  (setq ido-use-faces nil))

(use-package nxml-mode
  :mode (".xml" ".xbl" ".xql" ".pmd" ".xsd")
  :bind (:map nxml-mode-map
              ("C-S-p" . dh/xml-format-buffer))
  :config
  (setq indent-tabs-mode nil)
  (setq tab-width 2))

(use-package mz-comment-fix
  :load-path "site-lisp"
  :config (add-to-list 'comment-strip-start-length (cons 'nxml-mode 3)))

(use-package sql-mode
  :mode (".sql" ".vw" ".trg" ".fnc" ".prc")
  :bind (:map sql-mode-map
              ("C-S-p" . dh/sql-format-buffer))
  :config
  (add-hook 'sql-mode-hook
            (lambda ()
              (setq indent-tabs-mode nil))))

(use-package restclient-mode
  :mode (".http"))

(use-package projectile
  :bind (:map projectile-mode-map
              ([S-f] . projectile-find-file)
              ([S-g] . projectile-grep)))

(use-package highlight-symbol
  :bind (([double-mouse-1] . highlight-symbol-at-point)
         ("<f3>" . highlight-symbol-at-point)
         ("C-<f3>" . highlight-symbol-next)
         ("S-<f3>" . highlight-symbol-prev)
         ("C-S-<f3>" . highlight-symbol-mode)))

(use-package vc-fossil
  :config (add-to-list 'vc-handled-backends 'Fossil))

(use-package java-mode
  :mode (".java" ".jad"))

(use-package clojure-mode
  :mode (".clj" ".cljx"))

(use-package clojurescript-mode
  :mode (".cljs"))

(use-package hideshow
  :bind (("C-M-#" . hs-toggle-hiding)
         ("C-+" . hs-toggle-hiding))
  :config
  (add-hook 'c-mode-common-hook   'hs-minor-mode)
  (add-hook 'emacs-lisp-mode-hook 'hs-minor-mode)
  (add-hook 'java-mode-hook       'hs-minor-mode)
  (add-hook 'lisp-mode-hook       'hs-minor-mode)
  (add-hook 'perl-mode-hook       'hs-minor-mode)
  (add-hook 'sh-mode-hook         'hs-minor-mode)
  (defvar hs-special-modes-alist
    (mapcar #'purecopy
            '((c-mode "{" "}" "/[*/]" nil nil)
              (c++-mode "{" "}" "/[*/]" nil nil)
              (groovy-mode "{" "}" "/[*/]" nil nil)
              (bibtex-mode ("@\\S(*\\(\\s(\\)" 1))
              (java-mode "{" "}" "/[*/]" nil nil)
              (js-mode "{" "}" "/[*/]" nil)))))

(use-package js-mode
  :mode ".js"
  :config
  (setq js-indent-level 4)
  (setq indent-tabs-mode nil))

(use-package groovy-mode
  :mode ".groovy"
  :config
  (setq c-basic-offset 4)
  (setq groovy-program-name "groovysh")
  (add-hook 'groovy-mode-hook 'dh/groovy-mode-setup))


;; TODO: will not connect
;; see https://itdesign.hipchat.com/account/xmpp
;; see https://gist.github.com/bitops/77308b347bceb54302a2
;; (use-package jabber
;;   :init
;;   (setq ssl-program-name "gnutls-cli"
;;         ssl-program-arguments '("--insecure" "-p" service host)
;;         ssl-certificate-verification-policy 1
;;         jabber-account-list '(("156097_1883522@chat.hipchat.com"
;; 			       (:port . 5222)
;;                                (:network-server . "chat.hipchat.com")
;;                                (:password . "...")))))

(use-package server
  :if (equal window-system 'w32)
  ;; work-around for bug in Win32 server-start:
  :config (defun server-ensure-safe-dir (dir) "Noop" t))


(set-register ?m "mvn clean source:jar compile install")
(set-register ?g "${gel_objectInstanceId}")
(set-register ?s "/smb:Administrator@:/c$/")

(setq history-length 1000
      inhibit-splash-screen t
      global-font-lock-mode t
      indent-tabs-mode nil
      display-time-24hr-format t
      visible-bell t)

(tool-bar-mode -1)
(menu-bar-mode -1)
(global-hl-line-mode t)

(when (>= emacs-major-version 23)
  (transient-mark-mode -1)
  (global-visual-line-mode -1)
  (setq line-mode-visual nil)
  (setq truncate-lines t))


;; (server-start)

;; --------------------------------------------
;; Unicode setup: Immer UTF-8 ohne BOM verwenden.
(prefer-coding-system 'utf-8)

;; niemals BOMs benutzen: http://superuser.com/questions/41254/make-emacs-not-remove-the-bom-from-xml-files
(setq auto-coding-regexp-alist
      (delete (rassoc 'utf-16be-with-signature auto-coding-regexp-alist)
              (delete (rassoc 'utf-16le-with-signature auto-coding-regexp-alist)
                      (delete (rassoc 'utf-8-with-signature auto-coding-regexp-alist)
                              auto-coding-regexp-alist))))


;;-----------------------------
;; Note from (emacs)Keymaps:
;; >  C-c followed by a letter is reserved for the user and no mode should
;; >  bind anything there.

;; All "C-c [a-zA-Z]" are reserved for the user...
;; so assign useful things to them!
(global-set-key (kbd "C-c m") 'comment-region)
(global-set-key (kbd "C-c M") 'uncomment-region)
(global-set-key (kbd "C-c C-m") 'hide-dos-eol)
(global-set-key (kbd "C-c <tab>") 'indent-region)
(global-set-key (kbd "C-c C-<tab>") 'untabify)
(global-set-key (kbd "C-c w") 'window-configuration-to-register)
(global-set-key (kbd "C-c t") 'toggle-truncate-lines)
(global-set-key (kbd "C-c h") 'highlight-regexp)
(global-set-key (kbd "C-c H") 'unhighlight-regexp)
(global-set-key (kbd "C-c s") 'speedbar)
(global-set-key (kbd "C-c a") 'beginning-of-buffer)
(global-set-key (kbd "C-c e") 'end-of-buffer)
(global-set-key (kbd "C-c l") 'hl-line-mode)
(global-set-key (kbd "C-c L") 'linum-mode)
(global-set-key (kbd "C-c k") 'apply-macro-to-region-lines)  ; auch gut: C-0 C-x e (exec. bis Ende)
(global-set-key (kbd "C->")   'increase-left-margin)         ; indent
(global-set-key (kbd "C-<")   'decrease-left-margin)         ; outdent

(global-set-key (kbd "C-<f5>") 'revert-buffer)
(global-set-key (kbd "C-c C-<f5>") 'auto-revert-tail-mode)   ; "tail -f"; use for log files
(global-set-key (kbd "<f7>") 'rgrep)
(global-set-key (kbd "C-<f7>") 'occur)

(global-set-key (kbd "C-z") nil)

;;; obsolete: C-x C-+ now does it.
;; (global-set-key (kbd "C-M-+") 'text-scale-increase)
;; (global-set-key (kbd "C-M--") 'text-scale-decrease)


;; idea from http://www.emacswiki.org/emacs/OccurMode
(global-set-key (kbd "<C-kp-divide>") 'previous-error)
(global-set-key (kbd "<C-kp-multiply>") 'next-error)

;; make cursor movement keys under right hand's home-row (from Xah Lee)
(global-set-key (kbd "M-j") 'backward-char) ; was indent-new-comment-line
(global-set-key (kbd "M-l") 'forward-char)  ; was downcase-word
(global-set-key (kbd "M-i") 'previous-line) ; was tab-to-tab-stop
(global-set-key (kbd "M-k") 'next-line)     ; was kill-sentence


;;-----------------------------
;; various system predicates
(defun x11p () (equal window-system 'x))
(defun w32p () (equal window-system 'w32))


;;-----------------------------
;; abbrev-mode
(setq abbrev-file-name "~/.emacs.d/abbrev_defs"
      save-abbrevs t
      default-abbrev-mode t)
(if (file-exists-p abbrev-file-name)
    (quietly-read-abbrev-file))

;;-----------------------------
(defun user-full-name ()
  "Dirk Hüsken")

;;-----------------------------
;; Prepare mode for Scheme48:

;; send an entire buffer to the scheme48 process
(defun scheme48-send-buffer ()
  (interactive)
  (scheme48-send-region (point-min) (point-max)))

;; indent a Scheme sexp nively, even when point is not in its first line
(defun scheme-indent-defun ()
  (interactive)
  (save-excursion
    (beginning-of-defun)
    (indent-sexp)))

(use-package cmuscheme48
  :if nil
  :bind (:map scheme-mode-map
              ("C-c b" . scheme48-send-buffer)
              ("C-c q" . scheme-indent-defun)
              ("C-c C-e" . scheme48-send-definition)
              ("C-c e" . end-of-buffer))
  :config (setq scheme-program-name "/home/dh/bin/s48-da"))

;; correct indentation for various non-standard scheme forms
(put 'let-values 'scheme-indent-function 1)
(put 'enum-case 'scheme-indent-function 2)
(put 'receive 'scheme-indent-function 2)


;;-----------------------------
;; prepare C/C++ mode
(add-hook 'c-mode-common-hook
          (lambda ()
            (turn-on-font-lock)
            (c-set-offset 'substatement-open 0)))


;;-----------------------------
;; prepare nXML mode
(defun dh/xml-format-buffer ()
  (interactive)
  (shell-command-on-region
   (point-min) (point-max) "xmllint --encode utf-8 --format --recover -" nil t))

(defun dh/sql-format-buffer ()
  (interactive)
  (shell-command-on-region
   (point-min) (point-max) "/home/dh/app/SqlFormatter.1.5.1/SqlFormatter.exe  /sac+ " nil t))


;;     (require 'groovy-mode)
;;     (defun dh-groovy-mode-setup ()
;;       (setq c-basic-offset 4
;;              indent-tabs-mode nil)
;;       (groovy-electric-mode 0))
;;     
;;     (add-hook 'groovy-mode-hook
;;               'dh-groovy-mode-setup)
;;     
;;     (setq interpreter-mode-alist (append '(("groovy" . groovy-mode))
;;                                           interpreter-mode-alist))
;;     (autoload 'groovy-mode "groovy-mode" "Groovy mode." t)
;;     (autoload 'run-groovy "inf-groovy" "Run an inferior Groovy process")
;;     (autoload 'inf-groovy-keys "inf-groovy" "Set local key defs for inf-groovy in groovy-mode")
;;     
;;     (add-hook 'groovy-mode-hook
;;                '(lambda ()
;;                   (inf-groovy-keys)))
;;     
;;     ;; can set groovy-home here, if not in environment
;;     (setq inferior-groovy-mode-hook
;;           '(lambda()
;;               (setq groovy-home "/home/dh/app/groovy-2.4.3/")
;;               (setq groovy-program-name (concat groovy-home "groovysh"))))
;;     

(defun dh/groovy-mode-setup ()
  (setq c-basic-offset 4)
  (setq indent-tabs-mode nil)
  (groovy-electric-mode 0))


;;-----------------------------
;; misc settings
;; TeX/AucTeX settings
(setq tex-open-quote "\"`")   ; German open/close quote
(setq tex-close-quote "\"'")

;; TRAMP setup for editing remote files over ssh
(setq tramp-default-method "sshx")
(setq password-cache-expiry 3600)  ; remember passwords 1h max

;; ERC customization (can also be in ~/.ercrc.el)
(setq erc-nick "dirchh")
(setq erc-hide-list '("JOIN" "PART" "QUIT"))


;; enable cycling through windows:
;; C-x <down>  C-x o  forward
;; C-x <up>    C-x p  backward
(define-key ctl-x-map "p" 'previous-multiframe-window)
(define-key ctl-x-map [up] 'previous-multiframe-window)
(define-key ctl-x-map [down] 'next-multiframe-window)

(global-set-key [C-tab] [M-tab])


;; dh: call occur with current isearch (C-s) query
(defun isearch-occur ()
  "Invoke `occur' from within isearch."
  (interactive)
  (let ((case-fold-search isearch-case-fold-search))
    (occur (if isearch-regexp isearch-string (regexp-quote isearch-string)))))
(define-key isearch-mode-map (kbd "C-o") 'isearch-occur)


(defun toggle-scratchpad (prefix)
  "Toggle a window with the file ~/scratchpad.org"
  (interactive "P")
  (if (string-equal (buffer-name) "scratchpad.org")
      (jump-to-register ?S)
    (progn
      (window-configuration-to-register ?S)
      (if (not prefix)
          (split-window-vertically)
        (split-window-horizontally))
      (if (get-buffer "scratchpad.org")
          (switch-to-buffer "scratchpad.org")
        (find-file "~/scratchpad.org")))))
(global-set-key (kbd "<f12>") 'toggle-scratchpad)
(global-set-key (kbd "C-<f12>") (lambda () (interactive) (toggle-scratchpad t)))


(defun run-or-switch-to-shell ()
  "If a *shell* buffer exists, switch to it; otherwise, start a new shell"
  (interactive)
  (if (memq "*shell*"
            (mapcar #'buffer-name (buffer-list)))
      (switch-to-buffer "*shell*")
    (shell)))
(global-set-key (kbd "<f4>") 'run-or-switch-to-shell)

(defun find-in-gitroot ()
  "Load dired for /gitroot"
  (interactive)
  (find-file "/gitroot"))
(global-set-key (kbd "<f10>") 'find-in-gitroot)

;; (global-set-key (kbd "C-<f11>") 'toggle-frame-fullscreen) ;; mapped to <f11> on 24.4


(defun insert-date (prefix)
  "Insert the current date. With prefix-argument, use ISO format. With
   two prefix arguments, write out the day and month name."
  (interactive "P")
  (let ((format (cond
                 ((not prefix) "%d.%m.%Y")
                 ((equal prefix '(4)) "%Y-%m-%d")
                 ((equal prefix '(16)) "%A, %d. %B %Y")))
        (system-time-locale "de_DE"))
    (insert (format-time-string format))))
(global-set-key (kbd "C-c d") 'insert-date)

(defun insert-at-and-indent-and-comment (pos str)
  (save-excursion
    (goto-char pos)
    (insert-string str)
    (indent-according-to-mode)
    (newline)
    (comment-region pos (point))))

(defun insert-id+time-stamp (prefix)
  "itd: Insert an itd customization comment as a proper comment according to the
   current mode.
   With a prefix arg, ask for a task, ref, fileref, description in the minibuffer."
  (interactive "P")
  (save-excursion
    (beginning-of-line)
    (let ((start-pos (point)))
      (if (null prefix)
          (let* ((filerefno (read-from-minibuffer "Fileref: "))
                 (start-str (concat "@@" filerefno
                                    " " (user-login-name) "@itdesign.de "
                                    (format-time-string "%Y-%m-%d")))
                 (end-str (concat "@@/" filerefno)))
            (cond ((use-region-p)
                   (insert-at-and-indent-and-comment (region-beginning) start-str)
                   (next-line)
                   (insert-at-and-indent-and-comment (region-end) end-str) )
                  (t
                   (insert-at-and-indent-and-comment (point) start-str)
                   (next-line)
                   (insert-at-and-indent-and-comment (point) end-str))))
        (let* ((filerefno (read-from-minibuffer "Fileref: "))
               (desc (read-from-minibuffer "Beschreibung (desc): "))
               (refno (read-from-minibuffer "Vorgang (ref): "))
               (modno (read-from-minibuffer "Vorgang (mod): ")))
          (unless (zerop (length filerefno))
            (insert-string (concat "@fileref: @@" filerefno)))
          (insert-string (concat " @author: " (user-login-name) "@itdesign.de"))
          (insert-string (concat " @date: " (format-time-string "%Y-%m-%d")))
          (unless (zerop (length refno))
            (insert-string (concat " @ref: " refno)))
          (unless (zerop (length modno))
            (insert-string (concat " @mod: " modno)))
          (unless (zerop (length desc))
            (newline)
            (insert-string (concat "@desc: " desc)))
          (comment-region start-pos (point))))))
  (next-line))
(global-set-key (kbd "C-c i") 'insert-id+time-stamp)


(defun filename-to-register ()
  "Save the current filename to register f"
  (interactive)
  (set-register ?f (buffer-file-name)))
(global-set-key (kbd "C-c f") 'filename-to-register)
(global-set-key (kbd "C-c F") (lambda () (interactive) (insert-register ?f)))


;; from: http://emacsredux.com/blog/2013/03/27/indent-region-or-buffer/
(defun indent-buffer ()
  "Indent the currently visited buffer."
  (interactive)
  (indent-region (point-min) (point-max)))


(defun indent-region-or-buffer ()
  "Indent a region if selected, otherwise the whole buffer."
  (interactive)
  (save-excursion
    (if (region-active-p)
        (progn
          (indent-region (region-beginning) (region-end))
          (message "Indented selected region."))
      (progn
        (indent-buffer)
        (message "Indented buffer.")))))
(global-set-key (kbd "C-S-f") 'indent-region-or-buffer)


;; from: http://emacsredux.com/blog/2013/03/26/smarter-open-line/
(defun smart-open-line ()
  "Insert an empty line after the current line.
Position the cursor at its beginning, according to the current mode."
  (interactive)
  (move-end-of-line nil)
  (newline-and-indent))
(global-set-key [(shift return)] 'smart-open-line)


(defun hide-dos-eol ()
  "Do not show ^M in files containing mixed UNIX and DOS line endings."
  (interactive)
  (setq buffer-display-table (make-display-table))
  (aset buffer-display-table ?\^M []))


(defun run-kawa (prefix)
  "Run Kawa Scheme in an Emacs buffer."
  (interactive "P")
  (require 'cmuscheme)
  (let ((scheme-program-name (if (null prefix)
                                 "~/bin/kawa"
                               "~/bin/kawa-ppm-14.2")))
    (run-scheme scheme-program-name)))


(defun unix-file ()
  "Change the current buffer to Latin 1 with Unix line-ends."
  (interactive)
  (set-buffer-file-coding-system 'iso-latin-1-unix t))


;; for Emacs / Windows / Cygwin
(when (w32p)
  ;; c:/cygwin/bin in PATH aufnehmen, exec-path nicht anfassen.
  ;; Kopie von find.exe (cygwin) anlegen und find-program darauf zeigen lassen:
  (setq find-program "gnufind.exe")
  ;; inhibit command echoing for windows shells
  (setq explicit-cmdproxy.exe-args '("/q")))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; the stuff below was auto-generated by emacs:
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-faces-vector
   [default default default italic underline success warning error])
 '(ansi-color-names-vector
   ["#242424" "#e5786d" "#95e454" "#cae682" "#8ac6f2" "#333366" "#ccaa8f" "#f6f3e8"])
 '(background-color "#002b36")
 '(background-mode dark)
 '(blink-cursor-mode nil)
 '(canlock-password "67ca5d6d75c0a44551d0e4473b20cfdf9874431b")
 '(cursor-color "#839496")
 '(custom-enabled-themes (quote (professional)))
 '(custom-safe-themes
   (quote
    ("77c65d672b375c1e07383a9a22c9f9fc1dec34c8774fe8e5b21e76dca06d3b09" "75d807376ac43e6ac6ae3892f1f377a4a3ad2eb70b14223b4ed0355e62116814" "a041a61c0387c57bb65150f002862ebcfe41135a3e3425268de24200b82d6ec9" "1e7e097ec8cb1f8c3a912d7e1e0331caeed49fef6cff220be63bd2a6ba4cc365" "fc5fcb6f1f1c1bc01305694c59a1a861b008c534cae8d0e48e4d5e81ad718bc6" default)))
 '(default
    ((t
      (:stipple nil :background "SystemWindow" :foreground "SystemWindowText" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 98 :width normal :family "outline-consolas"))))
 '(display-time-mode t)
 '(foreground-color "#839496")
 '(indicate-empty-lines t)
 '(js-indent-level 2)
 '(load-home-init-file t t)
 '(longlines-auto-wrap nil)
 '(ls-lisp-verbosity nil)
 '(org-clock-into-drawer nil)
 '(projectile-global-mode t)
 '(safe-local-variable-values
   (quote
    ((sql-product . oracle)
     (sql-product . ms)
     (org-time-stamp-rounding-minutes 0 15)
     (Syntax . Scheme)
     (Package . Scheme))))
 '(scroll-bar-mode (quote right))
 '(show-paren-mode t)
 '(transient-mark-mode nil))

(put 'narrow-to-region 'disabled nil)
(put 'downcase-region 'disabled nil)
(put 'upcase-region 'disabled nil)
(put 'erase-buffer 'disabled nil)

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:family "Liberation Mono" :foundry "unknown" :slant normal :weight normal :height 98 :width normal)))))

