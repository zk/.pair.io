;; ELPA

;; Package Management
(require 'package)
(add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/"))
(add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/"))
(package-initialize)

(add-to-list 'load-path (concat "~/.emacs.d/me/auto-complete"))
;;(add-to-list 'load-path "~/.emacs.d/plugins/nav")
(add-to-list 'load-path (concat "~/.emacs.d/me/anything"))
;;(add-to-list 'load-path (concat "~/.emacs.d/me/scala-mode"))

(require 'color-theme)
(require 'linum)
(require 'paredit)
(require 'clojure-mode)
(require 'clojurescript-mode)
(require 'yasnippet)
(require 'ruby-mode)
;; (require 'ruby-mode-indent-fix)
(require 'eproject)
(require 'eproject-extras)
;;(require 'scala-mode)
(require 'smooth-scrolling)
;; (require 'centered-cursor-mode)
(require 'haml-mode)
(require 'js2-mode)

(require 'smex)
(smex-initialize)

(require 'window-numbering)
(window-numbering-mode 1)

(require 'undo-tree)

(global-set-key (kbd "C-_") 'undo)
(global-set-key (kbd "M-?") 'undo-tree-visualize)


;; (require 'anything-ack)

;; (setq window-numbering-assign-func
;;       (lambda () (when (equal (buffer-name) "*slime-repl clojure*") 9)))

;; (require 'anything-grep)

;; (require 'anything-git-grep)


(add-to-list 'load-path (concat "~/.emacs.d/me/ack-and-a-half.el"))
(autoload 'ack-and-a-half-same "ack-and-a-half" nil t)
(autoload 'ack-and-a-half "ack-and-a-half" nil t)
(autoload 'ack-and-a-half-find-file-same "ack-and-a-half" nil t)
(autoload 'ack-and-a-half-find-file "ack-and-a-half" nil t)
;; Create shorter aliases
(defalias 'ack 'ack-and-a-half)
(defalias 'ack-same 'ack-and-a-half-same)
(defalias 'ack-find-file 'ack-and-a-half-find-file)
(defalias 'ack-find-file-same 'ack-and-a-half-find-file-same)
(setq ack-and-a-half-prompt-for-directory t)


(global-set-key (kbd "M-x") 'smex)
(global-set-key (kbd "M-X") 'smex-major-mode-commands)
;; This is your old M-x.
(global-set-key (kbd "C-c C-c M-x") 'execute-extended-command)

(eval-after-load "color-theme"
  '(progn
     (color-theme-initialize)
     (color-theme-zkim)))

;; anything
(require 'anything)
(require 'anything-config)
(require 'anything-eproject)

(define-project-type lein (generic)
  (look-for "project.clj")
  :relevant-files (".*")
  :irrelevant-files ("^[.]" "^[#]" "\\.jar$" "\\.war$"))

;; linum setup
(setq linum-format "%d ")
(global-hl-line-mode 0)

;; same buffer
(nconc same-window-buffer-names '("*Apropos*" "*Buffer List*" "*Help*" "*anything*"))

(remove-hook 'coding-hook 'turn-on-hl-line-mode)
(add-hook 'esk-coding-hook 'esk-turn-on-whitespace)

(add-hook 'repl-mode (lambda () (paredit-mode)))

;;(turn-on-line-numbers-display)

(eval-after-load 'slime '(setq slime-protocol-version 'ignore))

(defmacro defclojureface (name color desc &optional others)
  `(defface ,name '((((class color)) (:foreground ,color ,@others))) ,desc :group 'faces))

(defclojureface clojure-parens       "#999999"   "Clojure parens")
(defclojureface clojure-braces       "DimGrey"   "Clojure braces")
(defclojureface clojure-brackets     "SteelBlue" "Clojure brackets")
(defclojureface clojure-keyword      "#499DF5"   "Clojure keywords")
(defclojureface clojure-namespace    "#c476f1"   "Clojure namespace")
(defclojureface clojure-java-call    "#729FCF"   "Clojure Java calls")
(defclojureface clojure-special      "#1BF21B"   "Clojure special")
;;(defclojureface clojure-double-quote "#1BF21B"   "Clojure special" (:background "unspecified"))

(defun tweak-clojure-syntax ()
  (mapcar (lambda (x) (font-lock-add-keywords nil x))
          '((("#?['`]*(\\|)"       . 'clojure-parens))
            (("#?\\^?{\\|}"        . 'clojure-brackets))
            (("\\[\\|\\]"          . 'clojure-braces))
            ((":\\w+"              . 'clojure-keyword))
            (("#?\""               0 'clojure-double-quote prepend))
            (("nil\\|true\\|false\\|%[1-9]?" . 'clojure-special))
            (("(\\(\\.[^ \n)]*\\|[^ \n)]+\\.\\|new\\)\\([ )\n]\\|$\\)" 1 'clojure-java-call)))))

(add-hook 'clojure-mode-hook 'tweak-clojure-syntax)

;; One-offs
;; Better indention (from Kevin)
(add-hook 'clojure-mode-hook (lambda () (setq clojure-mode-use-backtracking-indent t)))
;; paredit in REPL
(add-hook 'slime-repl-mode-hook (lambda () (paredit-mode +1)))
;; syntax in REPL
;;(add-hook 'slime-repl-mode-hook 'clojure-mode-font-lock-setup)

;; Unicode stuff
(set-language-environment "UTF-8")
(setq slime-net-coding-system 'utf-8-unix)

;; Expression register

(defun copy-expression-to-buffer ()
  (interactive)
  (let ((form (slime-defun-at-point)))
    (setq clj-expression-buffer form))
  (message "Expression copied to buffer."))

(defun send-expression-in-buffer ()
  (interactive)
  (slime-interactive-eval clj-expression-buffer))

(defun eproject-anything ()
  (interactive)
  (anything-other-buffer '(
                           anything-c-source-eproject-files)
                         "*anything*"))

;; Key Bindings
(global-set-key (kbd "C-x C-y") 'anything-show-kill-ring)
;; (global-set-key (kbd "C-x y") 'browse-kill-ring)

(global-set-key (kbd "C-c e") 'copy-expression-to-buffer)
(global-set-key (kbd "C-c l") 'send-expression-in-buffer)

(add-hook 'clojure-mode-hook 'yas/minor-mode-on)

;; (define-key paredit-mode-map (kbd "M-i") 'save-buffer)
(define-key clojure-mode-map (kbd "C-o") 'slime-eval-defun)

(define-key emacs-lisp-mode-map (kbd "C-o") 'eval-defun)

(define-key paredit-mode-map (kbd "M-SPC") 'anything)
(define-key clojure-mode-map (kbd "M-SPC") 'anything)
(global-set-key (kbd "M-SPC") 'anything)
(define-key paredit-mode-map (kbd "C-j") 'save-buffer)
(define-key clojure-mode-map (kbd "C-j") 'save-buffer)
(define-key ruby-mode-map (kbd "C-j") 'save-buffer)
(global-set-key (kbd "M-t") 'eproject-anything)
(global-set-key (kbd "C-j") 'save-buffer)
(global-set-key (kbd "C-_") 'undo)

(global-set-key (kbd "C-w") 'backward-kill-word)
(define-key paredit-mode-map (kbd "C-w") 'paredit-backward-kill-word)
(global-set-key (kbd "M-DEL") 'kill-region)
(define-key paredit-mode-map (kbd "M-DEL") 'kill-region)
;;(define-key html-mode-map (kbd "<RET>") 'reindent-then-newline-and-indent)
;;(define-key js-mode-map (kbd "<RET>") 'reindent-then-newline-and-indent)


(defun what-face (pos)
  (interactive "d")
  (let ((face (or (get-char-property (point) 'read-face-name)
                  (get-char-property (point) 'face))))
        (if face (message "Face: %s" face) (message "No face at %d" pos))))

(defun toggle-fullscreen () (interactive) (ns-toggle-fullscreen))
(global-set-key [f11] 'toggle-fullscreen)

(setq visible-bell nil)

(setq yas/root-directory "~/.emacs.d/snippets/")
(yas/load-directory yas/root-directory)

(defun kill-whitespace ()
  "Kill the whitespace between two non-whitespace characters"
  (interactive "*")
  (save-excursion
    (save-restriction
      (save-match-data
        (progn
          (re-search-backward "[^ \t\r\n]" nil t)
          (re-search-forward "[ \t\r\n]+" nil t)
          (replace-match "" nil nil))))))

(global-set-key (kbd "M-\\") 'kill-whitespace)
(global-set-key (kbd "C-\\") 'kill-whitespace)




;; Ruby

(define-key ruby-mode-map (kbd "M-q") 'ruby-indent-exp)

;; CoffeeScript
(add-to-list 'load-path (concat "~/.emacs.d/me/coffee-mode"))
(require 'coffee-mode)


;; dirtree
(require 'tree-mode)
(require 'windata)
(require 'dirtree)

(defun ep-dirtree ()
  (interactive)
  (dirtree-in-buffer eproject-root t))


;; ido
(define-key ido-file-completion-map (kbd "C-w") 'ido-delete-backward-word-updir)


;; what face?

(defun what-face (pos)
  (interactive "d")
  (let ((face (or (get-char-property (point) 'read-face-name)
                  (get-char-property (point) 'face))))
    (if face (message "Face: %s" face) (message "No face at %d" pos))))

;; CSS
(setq css-indent-offset 2)
(setq js-indent-level 2)

;; Mode to file extension associations
(add-to-list 'auto-mode-alist '("\\.scss$" . css-mode))
(add-to-list 'auto-mode-alist '("\\.bldr$" . ruby-mode))
(add-to-list 'auto-mode-alist '("\\.hamlc$" . haml-mode))

;; (custom-set-variables
;;   ;; custom-set-variables was added by Custom.
;;   ;; If you edit it by hand, you could mess it up, so be careful.
;;   ;; Your init file should contain only one such instance.
;;   ;; If there is more than one, they won't work right.
;;  '(next-screen-context-lines 4))

(setq
 scroll-margin 5)



;; (defadvice next-window
;;   (after track-last-eproject-root activate)
;;   (message "On next window!")
;;   (message eproject-root))

;; (defadvice previous-window
;;   (after track-last-eproject-root activate)
;;   (message "On next window!")
;;   (message eproject-root))

;; (defadvice other-window
;;   (after track-last-eproject-root activate)
;;   (message "On next window!")
;;   (message eproject-root))

(add-hook 'coffee-mode-hook
          '(lambda () (set (make-local-variable 'tab-width) 2)))


(global-set-key (kbd "<ESC> <left>") 'windmove-left)
(global-set-key (kbd "<ESC> <right>") 'windmove-right)
(global-set-key (kbd "<ESC> <up>") 'windmove-up)
(global-set-key (kbd "<ESC> <down>") 'windmove-down)


(setq mac-command-modifier 'meta)
(setq mac-option-modifier 'super)

(defadvice yes-or-no-p (around prevent-dialog activate)
  "Prevent yes-or-no-p from activating a dialog"
  (let ((use-dialog-box nil))
    ad-do-it))

(defadvice y-or-n-p (around prevent-dialog-yorn activate)
  "Prevent y-or-n-p from activating a dialog"
  (let ((use-dialog-box nil))
    ad-do-it))

;; Syntax-highlight org mode code blocks
(setq org-src-fontify-natively t)
