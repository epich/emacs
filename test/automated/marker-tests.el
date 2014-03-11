;;; marker-tests.el --- tests for common markers such as the mark -*- lexical-binding:t -*-

;; Copyright (C) 2014 Free Software Foundation, Inc.

;; This file is part of GNU Emacs.

;; GNU Emacs is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; GNU Emacs is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;;; Code:

(ert-deftest marker-tests-mark-rings ()
  (let ((buf1 (generate-new-buffer "buf1"))
        (buf2 (generate-new-buffer "buf2")))
    (set-buffer buf1)
    (insert "abcdefg")
    (push-mark 1)
    (goto-char 2)
    (push-mark)
    (set-buffer buf2)
    (insert "ABCDEFG")
    (push-mark)
    (set-buffer buf1)
    (pop-global-mark)
    (should (eq (current-buffer) (marker-buffer (mark-marker))))
    (should (eq (current-buffer) buf2))
    (goto-char 3)
    (pop-mark) ; Shouldn't go anywhere, mark-ring empty
    (should (= 3 (point)))
    (pop-global-mark)
    (should (eq (current-buffer) buf1))
    (push-mark 4)
    (should (= 4 (mark t)))
    (goto-char 5)
    (exchange-point-and-mark)
    (should (= 4 (point)))
    (should (= 5 (marker-position (mark-marker))))
    (pop-mark)
    (should (= 2 (mark t)))
    (pop-mark)
    (should (= 1 (mark t)))
    (should (= 4 (point)))
    (should (eq (current-buffer) buf1))))

;;; marker-tests.el ends here


