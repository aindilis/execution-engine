(global-set-key "\C-cexac" 'execution-engine-add-constraint-to-respective-keyword-file)

(defun execution-engine-add-constraint-to-respective-keyword-file ()
 (interactive)
 (let* ((sexp (kmax-sexp-string-at-point))
	(keyword (prin1-to-string (nth 0 (sexp-at-point)))))
  (if (not (equal keyword nil))
    (let* ((current-buffer (current-buffer))
	   (filename (radar-select-directory
		      (kmax-get-all-subdirectories-of-directories-in-list action-planner-rules-directories-list)
		      keyword)))
     (if (file-exists-p filename)
      (progn
       (kill-sexp)
       (delete-blank-lines)
       (save-excursion
	(ffap filename)
	(beginning-of-buffer)
	(insert (concat sexp "\n"))
	(backward-sexp)
	(do-todo-pretty-print-sexp-at-point))
       ;; (switch-to-buffer current-buffer)
       ))))))

