(require 'clojure-mode)

(define-derived-mode clojurescript-mode clojure-mode "ClojureScript"
  "Major mode for ClojureScript")

(add-to-list 'auto-mode-alist '("\\.cljs$" . clojurescript-mode))

(setq inferior-lisp-program "lein trampoline cljsbuild repl-listen")

(define-key clojurescript-mode-map (kbd "C-o") 'lisp-eval-defun)
(define-key clojurescript-mode-map (kbd "C-c k") 'lisp-eval-region)

(when (and (featurep 'paredit) paredit-mode (>= paredit-version 21))
  (define-key clojurescript-mode-map "{" 'paredit-open-curly)
  (define-key clojurescript-mode-map "}" 'paredit-close-curly))

(provide 'clojurescript-mode)
