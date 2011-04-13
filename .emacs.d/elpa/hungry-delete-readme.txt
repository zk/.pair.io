;;; Commentary:

;; This file contains all the necessary functions and macros, taken from
;; cc-mode, to implement hungry deletion without relying on cc-mode.  This
;; allows it to be used more easily in all modes, as it is now a minor mode in
;; it's own right.

;;; Installation

;; To use this mode, just put the following in your .emacs file:
;; (require 'hungry-delete)
;; and add turn-on-hungry-delete-mode to all relevant hooks.

