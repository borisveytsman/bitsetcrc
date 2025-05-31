PACKAGE=bitsetcrc


PDF = $(PACKAGE).pdf 

all:  ${PDF} $(PACKAGE).sty 


%.pdf:  %.dtx   $(PACKAGE).sty 
	pdflatex $<
	- bibtex $*
	pdflatex $<
	- makeindex -s gind.ist -o $*.ind $*.idx
	- makeindex -s gglo.ist -o $*.gls $*.glo
	pdflatex $<
	while ( grep -q '^LaTeX Warning: Label(s) may have changed' $*.log) \
	do pdflatex $<; done


%.sty:   %.ins %.dtx  
	pdflatex $<


clean:
	$(RM)  *.log *.aux \
	*.cfg *.glo *.idx *.toc \
	*.ilg *.ind *.out *.lof \
	*.lot *.bbl *.blg *.gls \
	*.dvi *.ps *.thm *.tgz *.zip *.rpi \
        *.hd  *.sty 


distclean: clean
	$(RM) $(PDF) $(PACKAGE).sty 

#
# Archive for the distribution. Includes typeset documentation
#
archive:  all clean
	COPYFILE_DISABLE=1  \
	tar -C .. -czvf ../$(PACKAGE).tgz --exclude '*~' 
	--exclude '*.tgz' --exclude '*.zip'  --exclude ".git*" $(PACKAGE)
	mv ../$(PACKAGE).tgz .

zip:  all clean
	make $(PACKAGE).sty
	$(RM) $(PACKAGE).log
	cd ..;\
	zip -r  $(PACKAGE).zip $(PACKAGE) -x "*.ins" -x "*.gitignore"

