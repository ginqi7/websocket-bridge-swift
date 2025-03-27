;;; websocket-bridge-swift.el ---                    -*- lexical-binding: t; -*-

;; Copyright (C) 2025  Qiqi Jin

;; Author: Qiqi Jin <ginqi7@gmail.com>
;; Keywords:

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <https://www.gnu.org/licenses/>.

;;; Commentary:

;;

;;; Code:

(defvar swift-command
  (expand-file-name "../../.build/arm64-apple-macosx/debug/websocket-bridge-swift-demo"))

(defun swift-demo-start ()
  "Start websocket bridge real-time-translation."
  (interactive)
  (websocket-bridge-app-start "swift-demo"
                              swift-command
                              ""))


(defun swift-demo-restart ()
  "Restart websocket bridge real-time-translation and show process."
  (interactive)
  (websocket-bridge-app-exit "swift-demo")
  (swift-demo-start)
  (websocket-bridge-app-open-buffer "swift-demo"))

(websocket-bridge-call "swift-demo" "message" "Hello")

(websocket-bridge-call "swift-demo" "value" "Hello")

(websocket-bridge-call "swift-demo" "runInEmacs" "Hello")


(provide 'websocket-bridge-swift)
;;; websocket-bridge-swift.el ends here
