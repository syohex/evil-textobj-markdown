;;; evil-textobj-markdown.el ---

;; Copyright (C) 2016 by Syohei YOSHIDA

;; Author: Syohei YOSHIDA <syohex@gmail.com>
;; URL: https://github.com/syohex/
;; Version: 0.01
;; Package-Requires: ((evil "1.0.0"))

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;;; Code:

(require 'evil)

(defgroup evil-textobj-markdown nil
  "Text object line for evil"
  :group 'evil)

(defcustom evil-textobj-markdown-i-key "m"
  "Keys for evil-inner-markdown"
  :type 'string)

(defcustom evil-textobj-markdown-a-key "m"
  "Keys for evil-a-markdown"
  :type 'string)

(defun evil-markdown-range (count beg end type &optional inclusive)
  (let* ((block-re "^[`~]\\{3\\}")
         (start (save-excursion
                  (unless (re-search-backward block-re nil t)
                    (error "Error: Here is not code block"))
                  (if inclusive
                      (match-beginning 0)
                    (forward-line +1)
                    (point))))
         (end (save-excursion
                (unless (re-search-forward block-re nil t)
                  (error "Error: Here is not code block"))
                (if inclusive
                    (match-end 0)
                  (forward-line -1)
                  (line-end-position)))))
    (evil-range start end)))

(evil-define-text-object evil-a-markdown (count &optional beg end type)
  "Select range between a character by which the command is followed."
  (evil-markdown-range count beg end type t))
(evil-define-text-object evil-inner-markdown (count &optional beg end type)
  "Select inner range between a character by which the command is followed."
  (evil-markdown-range count beg end type))

(define-key evil-outer-text-objects-map evil-textobj-markdown-a-key 'evil-a-markdown)
(define-key evil-inner-text-objects-map evil-textobj-markdown-i-key 'evil-inner-markdown)

(provide 'evil-textobj-markdown)

;;; evil-textobj-markdown.el ends here
