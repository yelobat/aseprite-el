;;; aseprite.el --- Interface with Aseprite's CLI from within Emacs -*- lexical-binding: t; -*-
;;
;; Copyright (C) 2025 Luke Holland
;;
;; Author: Luke Holland <yelobat@fedora>
;; Maintainer: Luke Holland <yelobat@fedora>
;; Created: August 19, 2025
;; Modified: August 19, 2025
;; Version: 0.0.1
;; Keywords: abbrev bib c calendar comm convenience data docs emulations extensions faces files frames games hardware help hypermedia i18n internal languages lisp local maint mail matching mouse multimedia news outlines processes terminals tex text tools unix vc wp
;; Homepage: https://github.com/yelobat/aseprite
;; Package-Requires: ((emacs "28.1") (transient "0.9.2") (compat "0.7.2"))
;;
;; This file is not part of GNU Emacs.
;;
;;; Commentary:
;;
;;  Description
;;
;;; Code:

;;

(require 'transient)

(defgroup aseprite nil
  "Interface with Aseprite's CLI."
  :group 'aseprite-cli)

(defcustom aseprite-cli-path "aseprite"
  "Path to Aseprite's executable."
  :type 'file
  :group 'aseprite)

(defconst aseprite--buffer (get-buffer-create "*Aseprite Buffer*"))
(defconst aseprite--error--buffer (get-buffer-create "*Aseprite Error Buffer"))
(defconst aseprite--process-name "aseprite-process")

(defun aseprite--sentinel (proc _string)
  "Handle termination of PROC and STRING.
If PROC is no longer alive, report its exit status in the echo area."
  (when (not (process-live-p proc))
    (let ((status (process-exit-status proc))
          (content (string-trim
                    (with-current-buffer
                        (process-buffer proc)
                      (buffer-string)))))
      (with-current-buffer (process-buffer proc)
        (erase-buffer))
      (if (zerop status)
          (message "%s" content)
        (message "Aseprite exited with status %d" status)))))

(defun aseprite--run-async (args)
  "Run Aseprite asynchronously with ARGS."
  (let ((proc (make-process
              :name aseprite--process-name
              :buffer (get-buffer-create "*Aseprite Process*")
              :command (append (list aseprite-cli-path) args)
              :filter nil
              :sentinel 'aseprite--sentinel)))
    proc))

(defun aseprite--transient-run ()
  "Run `aseprite' with the arguments gathered by the transient."
  (interactive)
  (let ((args (aseprite--transient-args-strip (transient-args 'aseprite-menu))))
    (aseprite--run-async args)
    (message "Aseprite started with args: %s" (mapconcat #'append args " "))))

(transient-define-suffix aseprite--show-args ()
  "Show the arguments that have been collected so far."
  (interactive)
  (let ((args (transient-args 'aseprite-menu)))
    (message "Collected args: %s"
             (if args (mapconcat #'append args " ") "(none)"))))

(defun aseprite--transient-transform-key (key)
  "Replace \"=\" with \" \" in KEY."
  (string-replace "=" " " key))

(defun aseprite--transient-strip-given-file (key)
  "Remove `--current-file=' from KEY."
  (string-replace "--current-file=" "" key))

(defun aseprite--transient-args-strip (args)
  "Apply a series of transformations to all ARGS."
  (let ((funcs '(aseprite--transient-strip-given-file
                 aseprite--transient-transform-key)))
    (dolist (func funcs args)
      (setq args (mapcar func args)))
    (split-string (mapconcat #'append args " ") " ")))

(transient-define-prefix aseprite-menu ()
  "Aseprite CLI Transient UI."
  [:description "Aseprite"
                ("r" "Execute Aseprite"
                 aseprite--transient-run
                 :description "Run Aseprite with the flags chosen above")]

  [:description "Basic switches"
                ("-S" "Start interactive shell" "--shell")
                ("-b" "Batch (no UI)" "--batch")
                ("-p" "Preview only" "--preview")
                ("-v" "Verbose" "--verbose")
                ("-?" "Help" "--help")
                ("-V" "Version" "--version")
                ("-d" "Debug (extreme verbose)" "--debug")
                ("-n" "Disable \"in game\" visibility on Steam" "--noinapp")]

  [:description "Files & I/O"
                ("--current-file" "Set the current file to be edited" "--current-file=")
                ("--save-as" "Save the current file into another file format" "--save-as=")
                ("--data" "File to store the sprite sheet metadata" "--data=")]

  [:description "Debugging Suffix"
                ("-a" "Show collected args" aseprite--show-args :transient t)])

(defun aseprite-kill ()
  "Kill the currently running Aseprite process, if any."
  (interactive)
  (when-let ((proc (get-process aseprite--process-name)))
    (kill-process proc)
    (message "Aseprite process killed")))

(provide 'aseprite)
;;; aseprite.el ends here
