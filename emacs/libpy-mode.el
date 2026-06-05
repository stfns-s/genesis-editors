;;; libpy-mode.el --- Major mode for libpy .lpy/.libpy templates -*- lexical-binding: t; -*-

;; Version: 0.3.0
;; Keywords: languages, liberty, python
;; Package-Requires: ((emacs "26.1") (mmm-mode "0.5.9"))
;;
;; This file mirrors `../vim/syntax/libpy.vim'. Unlike `genesispy-mode', there
;; is no Liberty base mode in Emacs, so this derives from `prog-mode' and only
;; overlays the embedded Python; the Liberty body is left unhighlighted.


(require 'mmm-mode)
(require 'mmm-auto)

(defgroup libpy nil
  "Major mode for gvpy Python-templated Liberty files."
  :group 'languages
  :prefix "libpy-")

(defface libpy-delim-face
  '((t :inherit font-lock-preprocessor-face))
  "Face for the libpy region delimiters: `//;' and the bracketing backticks."
  :group 'libpy)

(defface libpy-sentinel-face
  '((t :inherit font-lock-comment-face :weight bold))
  "Face for comment-only Python lines (`//; # ...' or `{% # ... %}')."
  :group 'libpy)

(defface libpy-j2-comment-face
  '((t :inherit font-lock-comment-face))
  "Face for Jinja2 `{# ... #}' template comments."
  :group 'libpy)

(defconst libpy--font-lock-keywords
  `(("^[ \t]*//;[ \t]*#.*$" . 'libpy-sentinel-face)
    ("//;\\(?:[^#]\\|$\\)" 0 'libpy-delim-face t)
    ("`" . 'libpy-delim-face)
    ;; --j2 delimiters. The whitespace modifiers `{%-' / `-%}'
    ;; are accepted by the parser as a syntactic no-op. The `{{ ... }}'
    ;; expression form is intentionally not highlighted, matching the Vim
    ;; and genesispy behaviour.
    ("{%-?[ \t]*#[^%]*%}" . 'libpy-sentinel-face)
    ("{%-?\\|-?%}" . 'libpy-delim-face)
    ("{#\\(?:.\\|\n\\)*?#}" 0 'libpy-j2-comment-face t))
  "Additional font-lock keywords for `libpy-mode'.")

;;;###autoload
(define-derived-mode libpy-mode prog-mode "Libpy"
  "Major mode for gvpy Python-templated Liberty files."
  (setq-local comment-start "/* ")
  (setq-local comment-end " */")
  (font-lock-add-keywords nil libpy--font-lock-keywords))

;;;###autoload
(progn
  (add-to-list 'auto-mode-alist '("\\.lpy\\'"   . libpy-mode))
  (add-to-list 'auto-mode-alist '("\\.libpy\\'" . libpy-mode)))

;; Emacs regex has no lookahead; exclusions are done via :front-verify.

(defun libpy--python-line-verify ()
  "Return non-nil unless the matched `//;' is a `//; # ...' comment line."
  (save-excursion
    (goto-char (match-end 0))
    (not (looking-at-p "[ \t]*#"))))

(defun libpy--j2-stmt-verify ()
  "Return non-nil unless the matched `{%' opens a `{% # ... %}' sentinel."
  (save-excursion
    (goto-char (match-end 0))
    (not (looking-at-p "-?[ \t]*#"))))

(mmm-add-classes
 '((libpy-python-line
    :submode python-mode
    :face mmm-code-submode-face
    :front "//;"
    :front-verify libpy--python-line-verify
    :back  "$"
    :include-front nil
    :include-back nil)
   (libpy-python-inline
    :submode python-mode
    :face mmm-code-submode-face
    :front "\\(?:^\\|[^\\\\]\\)\\(`\\)"
    :front-match 1
    :back  "\\(?:^\\|[^\\\\]\\)\\(`\\)"
    :back-match 1
    :include-front nil
    :include-back nil)
   (libpy-j2-stmt
    :submode python-mode
    :face mmm-code-submode-face
    :front "{%-?"
    :front-verify libpy--j2-stmt-verify
    :back  "-?%}"
    :include-front nil
    :include-back nil)))

(mmm-add-mode-ext-class 'libpy-mode nil 'libpy-python-line)
(mmm-add-mode-ext-class 'libpy-mode nil 'libpy-python-inline)
(mmm-add-mode-ext-class 'libpy-mode nil 'libpy-j2-stmt)

(provide 'libpy-mode)

;;; libpy-mode.el ends here
