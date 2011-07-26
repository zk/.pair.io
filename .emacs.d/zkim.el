;; ELPA
(when
    (load
     (expand-file-name "~/.emacs.d/package.el"))
  (package-initialize))

(add-to-list 'load-path "~/.emacs.d/zkim/auto-complete")
;;(add-to-list 'load-path "~/.emacs.d/plugins/nav")
(add-to-list 'load-path "~/.emacs.d/zkim/anything")
(add-to-list 'load-path "~/.emacs.d/zkim/scala-mode")

(require 'color-theme)
(require 'linum)
(require 'paredit)
(require 'clojure-mode)
(require 'yasnippet)
(require 'ruby-mode)
(require 'eproject)
(require 'eproject-extras)
(require 'scala-mode)

(eval-after-load "color-theme"
  '(progn
     (color-theme-initialize)
     (color-theme-zkim)))

;; auto-complete
;;(add-to-list 'load-path "~/.emacs.d/zkim/auto-complete")
;;(require 'auto-complete-config)
;;(add-to-list 'ac-dictionary-directories "~/.emacs.d/zkim/auto-complete/ac-dict")
;;(ac-config-default)

;; anything
(require 'anything)
(require 'anything-config)
(require 'anything-eproject)

;; (setq anything-sources
;;       (list
;;        anything-c-source-buffers+
;;        anything-c-source-file-name-history
;;        anything-c-source-eproject-files
;;        ))

;; (define-project-type git (generic)  ; Any dir with a .git directory
;;   (look-for ".git")
;;   :relavent-files (".*"))

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

(add-to-list 'auto-mode-alist '("\\.cljs$" . clojure-mode))

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
(define-key clojure-mode-map (kbd "M-t") 'eproject-anything)
(global-set-key (kbd "C-j") 'save-buffer)
(global-set-key (kbd "C-_") 'undo)

(global-set-key (kbd "C-w") 'backward-kill-word)
(define-key paredit-mode-map (kbd "C-w") 'paredit-backward-kill-word)
(global-set-key (kbd "M-DEL") 'kill-region)
(define-key paredit-mode-map (kbd "M-DEL") 'kill-region)


(defun what-face (pos)
  (interactive "d")
  (let ((face (or (get-char-property (point) 'read-face-name)
                  (get-char-property (point) 'face))))
        (if face (message "Face: %s" face) (message "No face at %d" pos))))

;;(defun toggle-fullscreen () (interactive) (ns-toggle-fullscreen))
;;(ns-toggle-fullscreen)
;;(global-set-key [f11] 'toggle-fullscreen)

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


;; Ruby

(define-key ruby-mode-map (kbd "M-q") 'ruby-indent-exp)

;; CoffeeScript
(add-to-list 'load-path "~/.emacs.d/zkim/coffee-mode")
(require 'coffee-mode)
