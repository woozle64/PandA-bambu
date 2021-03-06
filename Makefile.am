SUBDIRS =
DIST_SUBDIRS =

if BUILD_EXT
   SUBDIRS += ext
   DIST_SUBDIRS += ext
endif

SUBDIRS += panda_regressions examples src etc style
DIST_SUBDIRS += panda_regressions examples src etc style documentation

#########################################################
# Documentation section and rules
#########################################################
DOX_PROJECT_NAME= $(strip $(if $(subst $(shell (cd $(top_builddir); pwd )),,$(PWD)), $(strip $(subst /,_, $(subst $(shell (cd $(top_builddir); pwd ))/,,$(PWD)))), PandA))
# Directories and files to be scanned for the generation of the documentation
DOX_SRCFILES ="$(top_srcdir)/src $(top_srcdir)/documentation"
# Directory where the Doxygen \include command looks for file to be included
DOX_EXAMPLE_PATH=$(top_srcdir)
# Directory where the documentation will be placed
DOX_OUTPUTDIR=$(top_builddir)/documentation/
# Place where images can be found
DOX_IMG=$(top_srcdir)/documentation/img
# Logo
DOX_PROJECT_LOGO=$(top_srcdir)/style/img/panda.png.in
# Directory where custom header and footer can be found.
# Used only for latex with the new documentation build system
DOX_HF_DIR=$(top_srcdir)/style

.PHONY: documentation

documentation: $(top_builddir)/documentation/$(DOX_PROJECT_NAME)_html/index.html

$(top_builddir)/documentation/$(DOX_PROJECT_NAME)_html/index.html: Makefile $(top_srcdir)/etc/Doxyfile
	DOX_PROJECT_NAME=$(DOX_PROJECT_NAME) \
	DOX_VERSION=$(PACKAGE_VERSION) \
	DOX_PROJECT_LOGO=$(DOX_PROJECT_LOGO) \
	DOX_OUTPUTDIR=$(DOX_OUTPUTDIR) \
	DOX_SRCFILES=$(DOX_SRCFILES) \
	DOX_EXAMPLE_PATH=$(DOX_EXAMPLE_PATH) \
	DOX_IMG=$(DOX_IMG) \
	DOX_HF_DIR=$(DOX_HF_DIR) \
	  $(DOXYGEN) $(top_srcdir)/etc/Doxyfile;

EXTRA_DIST = Makefile.init README.md INSTALL.md

#Replace acinclude.m4
ACLOCAL_AMFLAGS = -I etc/macros


#do not touch the following line


dist-hook:
	$(top_srcdir)/etc/scripts/clean_configure.py $(top_srcdir)/configure.ac  | grep -v "#no_release_tag" > $(distdir)/configure.ac
	rm $(distdir)/aclocal.m4
	rm $(distdir)/missing
	rm $(distdir)/configure
	rm $(distdir)/depcomp
	rm $(distdir)/etc/aclocal.m4
	rm $(distdir)/etc/configure
	rm $(distdir)/etc/macros/ltversion.m4
	rm $(distdir)/ext/aclocal.m4
	rm $(distdir)/ext/configure
	rm $(distdir)/ext/flopoco/aclocal.m4
	rm $(distdir)/ext/flopoco/configure
	rm $(distdir)/ext/flopoco/m4/ltversion.m4
	rm $(distdir)/ext/libfplll-4.0.3/aclocal.m4
	rm $(distdir)/ext/libfplll-4.0.3/configure
	rm $(distdir)/ext/sollya/aclocal.m4
	rm $(distdir)/ext/sollya/configure
	rm -f $(distdir)/ext/sollya/m4/ltversion.m4
	rm $(distdir)/ltmain.sh
	rm `find $(distdir) -name Makefile.in`
	rm `find $(distdir) -name libtool.m4`
	rm `find $(distdir) -name lt~obsolete.m4`
	rm `find $(distdir) -name ltoptions.m4`
	rm `find $(distdir) -name ltsugar.m4`
	rm `find $(distdir) -name config.h.in`
	rm `find $(distdir) -name config.guess`
	rm `find $(distdir) -name ylwrap`
	rm `find $(distdir) -name compile`
	if test -f $(distdir)/test-driver; then rm $(distdir)/test-driver; fi
	cp $(srcdir)/ext/flopoco/Makefile.autotools $(distdir)/ext/flopoco/Makefile.autotools
	mkdir $(distdir)/ext/flopoco/autotools
	cp $(srcdir)/ext/flopoco/autotools/Makefile.am $(distdir)/ext/flopoco/autotools/Makefile.am
	cp $(srcdir)/ext/flopoco/autotools/configure.ac $(distdir)/ext/flopoco/autotools/configure.ac
	mkdir $(distdir)/ext/flopoco/autotools/src
	cp $(srcdir)/ext/flopoco/autotools/src/Makefile.am $(distdir)/ext/flopoco/autotools/src/Makefile.am
	cp $(builddir)/src/revision_hash.hpp $(distdir)/dist_revision_hash
	for file in \
	$(distdir)/src/parser/polixml/xmlLexer.cpp $(distdir)/src/parser/polixml/xmlParser.hpp $(distdir)/src/parser/polixml/xmlParser.h $(distdir)/src/parser/polixml/xmlParser.cpp \
	$(distdir)/src/parser/rtlgcc/rtlLexer.cpp $(distdir)/src/parser/rtlgcc/rtlParser.hpp $(distdir)/src/parser/rtlgcc/rtlParser.h $(distdir)/src/parser/rtlgcc/rtlParser.cpp \
	$(distdir)/src/parser/treegcc/treeLexer.cpp $(distdir)/src/parser/treegcc/treeParser.hpp $(distdir)/src/parser/treegcc/treeParser.h $(distdir)/src/parser/treegcc/treeParser.cpp \
	$(distdir)/src/parser/aadl/aadl_lexer.cpp $(distdir)/src/parser/aadl/aadl_yparser.hpp $(distdir)/src/parser/aadl/aadl_yparser.h $(distdir)/src/parser/aadl/aadl_yparser.cpp \
	$(distdir)/src/parser/asn/asn_lexer.cpp $(distdir)/src/parser/asn/asn_yparser.hpp $(distdir)/src/parser/asn/asn_yparser.h $(distdir)/src/parser/asn/asn_yparser.cpp \
	$(distdir)/src/parser/discrepancy/discrepancyLexer.cpp $(distdir)/src/parser/discrepancy/discrepancyParser.hpp $(distdir)/src/parser/discrepancy/discrepancyParser.h $(distdir)/src/parser/discrepancy/discrepancyParser.cpp; \
	do\
	   if test -f $$file; then\
	      rm $$file;\
	   fi \
	done
	cp $(top_srcdir)/etc/macros/mentor.m4.public $(distdir)/etc/macros/mentor.m4
	cp $(top_srcdir)/etc/macros/panda_ext_args.m4.public $(distdir)/etc/macros/panda_ext_args.m4
