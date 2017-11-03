;;; tsql-autoloads.el --- automatically extracted autoloads
;;
;;; Code:
(add-to-list 'load-path (or (file-name-directory #$) (car load-path)))

;;;### (autoloads nil "tsql" "tsql.el" (21822 7047 664855 864000))
;;; Generated autoloads from tsql.el

(autoload 'sql-highlight-tsql-keywords "tsql" "\
Highlight T-SQL keywords.
Set `font-lock-keywords' appropriately.

\(fn)" t nil)

(autoload 'sql-mode-keyword-upcase "tsql" "\
Upcase SQL keywords in range.

\(fn BEG END)" t nil)

(autoload 'sql-indent-line-get-info "tsql" "\
Get info about statement on current line.
Returns a list containing the following:
  type:     type of SQL statement
  keyword:  starting SQL keyword (lowercased)
  indent:   column number of indentation
Moves point to start of statement.  If in a comment block, will move point
to the start of the comment block.
You may call it again after doing `forward-word -1' to get info on the
previous statement.
Possible types are:
  bob:                   beginning of block
  comment-line:          -- type of comment
  comment-block-begin:   /* */ type of comment (first line)
  comment-block-end:     /* */ type of comment (last line)
  comment-block-middle:  /* */ type of comment (a middle line)
  blank:                 blank line
  begin:                 begin statement (block begin)
  end:                   end statement (block end)
  if-else:               if or else statement
  comment:               (should never happend; should get a more specific type, above)
  statement:             other sql statement
  statement-select:      an sql statement that may be followed by a select
  continue:              continuation of an sql statement

\(fn)" t nil)

(autoload 'sql-indent-line "tsql" "\
Indent current SQL line.

\(fn)" t nil)

(autoload 'indent-newline-and-indent "tsql" "\
Indent current line, then add a newline at the end, then indent the new line.

\(fn)" t nil)

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; End:
;;; tsql-autoloads.el ends here
