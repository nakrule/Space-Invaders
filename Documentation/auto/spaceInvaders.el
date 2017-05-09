(TeX-add-style-hook
 "spaceInvaders"
 (lambda ()
   (TeX-add-to-alist 'LaTeX-provided-class-options
                     '(("nakrule" "french")))
   (TeX-run-style-hooks
    "latex2e"
    "nakrule"
    "nakrule10")
   (TeX-add-symbols
    "runauthor"
    "runtitle")
   (LaTeX-add-labels
    "introduction"
    "sec:mario"
    "sec:gameplay"
    "architecture"
    "sec:label"
    "sec:dcm"
    "sec:display"
    "sec:input"
    "sec:rocketmanager"
    "sec:topmodule"
    "sec:package"))
 :latex)

