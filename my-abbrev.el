;; -*- coding: utf-8; lexical-binding: t; -*-
;; sample use of abbrev

(clear-abbrev-table global-abbrev-table)
(define-abbrev-table 'global-abbrev-table
  '(

    ;; net abbrev
    ("impd" "import pandas as pd" )
    ("imnp" "import numpy as np" )
    ))
(set-default 'abbrev-mode t)

(setq save-abbrevs nil)
