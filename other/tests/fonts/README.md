Subsets of Noto Sans and Noto Sans Arabic (SIL Open Font License 1.1, see `OFL.txt`), made with fontTools 4.60.1:

    pyftsubset NotoSans-Regular.ttf --text=fi --layout-features='*' --no-hinting --name-IDs='*' --output-file=NotoSans-fi.ttf
    pyftsubset NotoSansArabic-Regular.ttf --text=سلام --layout-features='*' --no-hinting --name-IDs='*' --output-file=NotoSansArabic-salam.ttf

`NotoSans-fi.ttf` has `f`, `i` and their `liga` ligature; `NotoSansArabic-salam.ttf` has the glyphs of `سلام`, with the lam-alef ligature.
