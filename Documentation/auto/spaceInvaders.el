(TeX-add-style-hook
 "spaceInvaders"
 (lambda ()
   (TeX-add-to-alist 'LaTeX-provided-class-options
                     '(("nakrule" "french")))
   (TeX-run-style-hooks
    "latex2e"
    "nakrule"
    "nakrule10"
    "infoBulle"
    "yFlatTable"
    "multirow"
    "calc")
   (TeX-add-symbols
    "runauthor"
    "runtitle")
   (LaTeX-add-labels
    "introduction"
    "sec:mario"
    "sec:gameplay"
    "gameOnArcade"
    "architecture"
    "sec:label"
    "alienRocketBloc"
    "alientable"
    "subsec:Entrées_Sorties_alienRocket"
    "sec:dcm"
    "dcmBloc"
    "subsec:Entrées_Sorties_dmc"
    "sec:display"
    "displayBloc"
    "sec:input"
    "inputBloc"
    "sec:rocketmanager"
    "rocketManagerBloc"
    "sec:vgainternal"
    "vgaInternalBloc"
    "sec:topmodule"
    "topModuleBloc"
    "sec:package"
    "sec:convertPicture"
    "subsec:Script1"
    "subsec:Script2"))
 :latex)

