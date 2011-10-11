# zkim's dotfiles

## Usage

curl https://raw.github.com/zkim/.pair.io/master/bootstrap | sh

## Emacs

* `C-j` -- save current buffer
* `C-w` -- backwards kill word

### Clojure

* `C-o` -- Send current sexp to swank server (slime-eval-defun).
* `C-c e` -- Send sexp under point to expression register.
* `C-c l` -- Send sexp in expression register to swank server.

### Anything
* `C-SPC` -- Open anything with buffers, recent files, and current
  dir.
* `M-t` -- Open anything with all files in current eproject
  (eproject-anything).

### Ido

* `C-x C-f` -- open file
  * `C-s` / `C-r` -- next / prev
  * `C-w` -- ido-delete-backward-word-updir

### Dirtree 

http://github.com/zkim/emacs-dirtree

* `M-x ep-dirtree` -- eproject-dirtree, will open dirtree with the root at the
  current eproject.
* `e` -- Toggle node
* `E` -- Expand node, prefix with 0 to expand all subtrees.
* `g` -- Refresh node
* `u` -- Up to parent
* `r` -- Up to root
* `!` -- Collapse other siblings


## Tmux

* `M-i` -- prefix command
