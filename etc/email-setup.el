;;; email-setup.el --- customize my personal email -*- lexical-binding: t; -*-

;;; Code:

(require 'utility)
(require 'notmuch)

(defun notmuch-address-selection-function (prompt collection initial-input)
  (completing-read prompt collection nil nil nil 'notmuch-address-history
                   initial-input))

(add-hook 'message-header-setup-hook
          (lambda ()
            (let* ((name (notmuch-user-name))
                   (email (notmuch-user-primary-email))
                   (header (format "Bcc: %s <%s>\n" name email)))
              (message-add-header header))))

(defun notmuch-search-toggle (tag)
  "Return a function that toggles TAG on the current item."
  (lambda ()
    (interactive)
    (if (member tag (notmuch-search-get-tags))
        (notmuch-search-tag (list (concat "-" tag) "+inbox"))
      (notmuch-search-tag (list (concat "+" tag) "-inbox" "-unread")))))

;; Notmuch mail listing keybindings.

(define-key notmuch-search-mode-map "g"
  'notmuch-search-refresh-view)

(define-key notmuch-search-mode-map "d"
  (notmuch-search-toggle "trash"))

(define-key notmuch-hello-mode-map "g"
  'notmuch-hello-poll-and-update)

(provide 'email-setup)

;;; email-setup.el ends here