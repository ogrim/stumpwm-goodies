(in-package :stumpwm)

(load "/home/ogrim/sites/stumpwm-goodies/mode-line/modeline-cpu.lisp")
;(load "modeline-cpu.lisp")
;(load (concat *stumpwm-load-path* "notifications.lisp"))

(setf *mode-line-screen-position* :bottom)
(setf *mode-line-frame-position* :bottom)
(setf *mode-line-border-width* 0)
(setf *mode-line-border-height* 0)
(setf *mode-line-pad-x* 0)
(setf *mode-line-pad-y* 1)
(setf *mode-line-background-color* "black")
(setf *mode-line-foreground-color* "grey")
(setf *mode-line-timeout* 2)
(setf *mode-line-border-color* "grey30")
(setf *window-format* "<%n%s%m%30t>")

(defun show-ip-address ()
  (let ((ip (run-shell-command "ip addr | grep eth0 | grep inet | cut -d' ' -f6" t)))
	(substitute #\Space #\Newline ip)))

(defun show-battery-charge ()
  (let ((raw-battery (run-shell-command "acpi | cut -d, -f2" t)))
    (substitute #\Space #\Newline raw-battery)))

(defun show-battery-remaining ()
  (let ((remaining (run-shell-command "acpi | awk '{ print $5 }'" t)))
    (substitute #\Space #\Newline remaining)))

(defun show-hostname ()
  (let ((host-name (run-shell-command "cat /etc/hostname" t)))
    (substitute #\Space #\Newline host-name)))

(defun show-battery-state ()
  (let ((raw-battery (run-shell-command "acpi | cut -d: -f2 | cut -d, -f1" t)))
    (substitute #\Space #\Newline raw-battery)))

(defun show-kernel ()
  (let ((ip (run-shell-command "uname -r" t)))
    (substitute #\Space #\Newline ip)))

(defun show-emacs-jabber-new-message ()
  (let ((new-message (run-shell-command "cat /home/joel/emacs-jabber.temp" t)))
;;;     (and (> (length new-message) 0) (stumpwm:message new-message))
    (substitute #\Space #\Newline new-message)))
;;;

(defun show-emacs-jabber-new-mail ()
  (let ((new-mail (run-shell-command "cat /home/joel/emacs-jabber-mail.temp" t)))
    (if (not (eq (length new-mail) 0))
        (progn (stumpwm:message new-mail)
               (run-shell-command "rm /home/joel/emacs-jabber-mail.temp" t)
               (run-shell-command "touch /home/joel/emacs-jabber-mail.temp" t)))
    ""))

(defun show-time-date ()
  (let ((time (run-shell-command "ruby -e \"print Time.now\"" t)))
    (substitute #\Space #\Newline time)))

;; Switch mode-line on
(toggle-mode-line (current-screen) (current-head))

;; Called from slime
(setf *JABBER-MODE-LINE* "")

;; Set model-line format
(setf *screen-mode-line-format*
      (list
       " "
       '(:eval (show-time-date))
       " | "
       '(:eval (show-hostname))
       "| Battery:"
       '(:eval (show-battery-charge))
       '(:eval (show-battery-state))
       '(:eval (show-battery-remaining))
       "| IP " '(:eval (show-ip-address))
       "| %g"))
