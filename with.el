;;; with.el --- `when-let*' with default bindings to intercept conditional failure -*- lexical-binding: t; -*-

;; Copyright (C) 2022  Conjunctive

;; Author: Conjunctive <conjunctive@protonmail.com>
;; Keywords: conditional binding default
;; Version: 0.0.1
;; URL: https://github.com/conjunctive/with
;; Package-Requires: ((emacs "27") cl-lib)

;; This program is free software: you can redistribute it and/or modify
;; it under the terms of the GNU Affero General Public License as
;; published by the Free Software Foundation, either version 3 of the
;; License, or (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU Affero General Public License for more details.

;; You should have received a copy of the GNU Affero General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; (with ((a <- 1)
;;        (b <- 2))
;;   (+ a b))

;; (with ((a <- nil
;;           <? 4)
;;        (b <- 2))
;;   (+ a b))

;; NOTE: Default branch only executed on failure.
;; (with ((a <- "a"
;;           <? (print "A"))
;;        (b <- "b"))
;;   (concat a b))

;;; Code:

(require 'cl-macs)

(defmacro with (spec &rest body)
  "Bind variables according to SPEC and conditionally evaluate BODY.
Optionally provide default values to avoid short-ciruitting on nil.
Effectively `when-let*' with default bindings to intercept conditional failure."
  (declare (indent 1))
  (cl-loop with body = `(progn ,@body)
           for expr in spec
           do (setq body
                    (pcase expr
                      (`(,a <- ,b)
                       `(let ((,a ,b))
                          (when ,a
                            ,body)))
                      (`(,a <- ,b <? ,c)
                       `(let ((,a (or ,b ,c)))
                          ,body))))
           finally return body))

(provide 'with)
;;; with.el ends here
