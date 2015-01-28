;;; edbi-minor-mode.el --- Use edbi with regular SQL files.

;; Copyright (C) 2015 by Artem Malyshev

;; Author: Artem Malyshev <proofit404@gmail.com>
;; URL: https://github.com/proofit404/edbi-minor-mode
;; Version: 0.0.1
;; Package-Requires: ((edbi "0.1.3"))

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program. If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; See the README for more details.

;;; Code:

(require 'edbi)

(defvar-local edbi-minor-mode-connection nil "")

(defvar-local edbi-minor-mode-result-buffer nil "")

(defvar edbi-minor-mode-map
  (let ((map (make-sparse-keymap)))
    (define-key map [remap sql-send-buffer] 'edbi-minor-mode-execute-buffer)
    (define-key map [remap sql-send-paragraph] 'edbi-minor-mode-execute-paragraph)
    (define-key map [remap sql-send-region] 'edbi-minor-mode-execute-region)
    (define-key map [remap sql-send-string] 'edbi-minor-mode-execute)
    map)
  "")

(define-minor-mode edbi-minor-mode
  ""
  :lighter " Edbi")

(defun edbi-minor-mode-execute (sql)
  ""
  (interactive "sSQL: ")
  (unless edbi-minor-mode-connection
    (setq edbi-minor-mode-connection
          (buffer-local-value 'edbi:connection
                              (get-buffer edbi:dbview-buffer-name))))
  (unless edbi-minor-mode-result-buffer
    (setq edbi-minor-mode-result-buffer
          (get-buffer-create
           (generate-new-buffer-name "*edbi-minor-mode-result*"))))
  (edbi:dbview-query-execute
   edbi-minor-mode-connection
   sql
   edbi-minor-mode-result-buffer))

(defun edbi-minor-mode-execute-paragraph ()
  ""
  (interactive)
  (let* ((start (save-excursion
                  (backward-paragraph)
                  (point)))
         (end (save-excursion
                (forward-paragraph)
                (point)))
         (sql (buffer-substring-no-properties start end)))
    (edbi-minor-mode-execute sql)))

(defun edbi-minor-mode-execute-region (start end)
  ""
  (interactive "r")
  (let ((sql (buffer-substring-no-properties start end)))
    (edbi-minor-mode-execute sql)))

(defun edbi-minor-mode-execute-buffer ()
  ""
  (interactive)
  (let ((sql (buffer-substring-no-properties (point-min) (point-max))))
    (edbi-minor-mode-execute sql)))

(provide 'edbi-minor-mode)

;;; edbi-minor-mode.el ends here
