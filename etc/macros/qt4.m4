##################################################################################
# Build Qt4 apps with the autotools (Autoconf/Automake).
# M4 macros.
# This file is part of AutoTroll.
# Copyright (C) 2006  Benoit Sigoure <benoit.sigoure@lrde.epita.fr>
#
# AutoTroll is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301,
# USA.
##################################################################################
# To integrate this set of macros in the PandA framework,
# this macro has been modified according the GNU General Public License
# by Fabrizio Ferrandi (ferrandi@elet.polimi.it).
##################################################################################
#

# ------------- #
# DOCUMENTATION #
# ------------- #

# Disclaimer: Never tested with anything else than Qt 4.2! Feedback welcome.
# Simply invoke AT_WITH_QT4 in your configure.ac. AT_WITH_QT4 can take
# arguments which are documented in depth below. The default arguments are
# equivalent to the default .pro file generated by qmake.
#
# Invoking AT_WITH_QT4 will do the following:
#  - Add a --with-qt4 option to your configure
#  - Find qmake, moc and uic and save them in the make variables $(QMAKE),
#    $(QT4_MOC), $(QT4_UIC).
#  - Save the path to Qt4 in $(QT4_PATH)
#  - Find the flags to use Qt4, that is:
#     * $(QT4_DEFINES): -D's defined by qmake.
#     * $(QT4_CFLAGS): CFLAGS as defined by qmake (C?!)
#     * $(QT4_CXXFLAGS): CXXFLAGS as defined by qmake.
#     * $(QT4_INCPATH): -I's defined by qmake.
#     * $(QT4_CPPFLAGS): Same as $(QT4_DEFINES) + $(QT4_INCPATH)
#     * $(QT4_LFLAGS): LFLAGS defined by qmake.
#     * $(QT4_LDFLAGS): Same thing as $(QT4_LFLAGS).
#     * $(QT4_LIBS): LIBS defined by qmake.
#
# You *MUST* invoke $(QT4_MOC) and/or $(QT4_UIC) where necessary. AutoTroll provides
# you with Makerules to ease this, here is a sample Makefile.am to use with
# AutoTroll which builds the code given in the chapter 7 of the Qt Tutorial:
# http://doc.trolltech.com/4.2/tutorial-t7.html
##################################################################################
# This part is different from the original one and it is adapted to the PandA
# framework.
# -------------------------------------------------------------------------
#
# noinst_LTLIBRARIES =  lib_settings.la
#
# bin_PROGRAMS = lcdrange
# lcdrange_SOURCES =  lcdrange.cpp lcdrange.h main.cpp
# lcdrange_CXXFLAGS = $(QT4_CXXFLAGS) $(AM_CXXFLAGS)
# lcdrange_CPPFLAGS = $(QT4_CPPFLAGS) $(AM_CPPFLAGS)
# lcdrange_LDFLAGS  = $(QT4_LDFLAGS) $(LDFLAGS)
# lcdrange_LDADD    = lib_settings.la $(QT4_LIBS) $(LDADD)
#
# noinst_HEADERS = Settings.ui.h
# lib_settings_la_MOC = Settings.moc.cpp
#
# lib_settings_la_UI = Settings.hpp Settings.cpp
# lib_settings_la_SOURCES = Settings.ui $(lib_settings_la_MOC) $(lib_settings_la_UI)
# BUILT_SOURCES = $(lib_settings_la_MOC) $(lib_settings_la_UI)
#
# CLEANFILES = $(BUILT_SOURCES)
#
# dist-hook:
#	rm -rf $(addprefix $(distdir)/, $(BUILT_SOURCES))
#
# -------------------------------------------------------------------------
#
# Note that your MOC, UIC and QRC files *MUST* be listed manually in
# BUILT_SOURCES. If you name them properly (eg: .moc.cpp, .qrc.cpp, .ui.cpp -- of
# course you can use .cpp or .cxx or .C rather than .cc) AutoTroll will build
# them automagically for you (using implicit rules defined in autotroll.mk).

m4_pattern_forbid([^AT_])dnl
m4_pattern_forbid([^_AT_])dnl

# AT_WITH_QT4([QT4_modules], [QT4_config], [QT4_misc])
# ------------------------------------------------
# Enable Qt4 support and add an option --with-qt4 to the configure script.
#
# The QT4_modules argument is optional and defines extra modules to enable or
# disable (it's equivalent to the QT variable in .pro files). Modules can be
# specified as follows:
#
# AT_WITH_QT4   => No argument -> No QT value.
#                                Qmake sets it to "core gui" by default.
# AT_WITH_QT4([xml])   => QT += xml
# AT_WITH_QT4([+xml])  => QT += xml
# AT_WITH_QT4([-gui])  => QT -= gui
# AT_WITH_QT4([xml -gui +sql svg])  => QT += xml sql svg
#                                     QT -= gui
#
# The QT4_config argument is also optional and follows the same convention as
# QT4_modules. Instead of changing the QT variable, it changes the CONFIG
# variable, which is used to tweak configuration and compiler options.
#
# The last argument, QT4_misc (also optional) will be copied as-is the .pro
# file used to guess how to compile Qt4 apps. You may use it to further tweak
# the build process of Qt4 apps if tweaking the QT4 or CONFIG variables isn't
# enough for you.
AC_DEFUN([AT_WITH_QT4],
[ AC_REQUIRE([AC_CANONICAL_HOST])
  AC_REQUIRE([AC_CANONICAL_BUILD])
  AC_REQUIRE([AC_PROG_CXX])

  test x"$TROLL" != x && echo 'ViM rox emacs.'

dnl Memo: AC_ARG_WITH(package, help-string, [if-given], [if-not-given])
  AC_ARG_WITH([qt4],
              [AS_HELP_STRING([--with-qt4],
                 [Path to Qt4 @<:@Look in PATH and in other standard places@:>@])],
              [QT4_PATH=$withval], [QT4_PATH=])

  if test "x$QT4_PATH" = x; then
  for dir in /usr/lib/qt4*/bin /usr/lib/qt-4*/bin /usr/local/Trolltech/bin/; do
     if test -n "`ls -1 $dir/qmake 2> /dev/null`"; then
          QT4_PATH="$dir";
     fi
  done
  fi

  # Find qmake.
  AC_PATH_PROGS([QMAKE], [qmake], [missing], [$QT4_DIR:$QT4_PATH:$PATH])
  if test x"$QMAKE" = xmissing; then
    AC_MSG_WARN([Cannot find qmake in your PATH. Try using --with-qt4.])
    have_qt4=no
  else
    have_qt4=yes
    # If we don't know the path to Qt4, guess it from the path to qmake.
    if test x"$QT4_PATH" = x; then
      QT4_PATH=`dirname "$QMAKE"`
    fi
    AC_SUBST([QT4_PATH])
  fi

  #########################################################
  #### only in case QT4 is installed
  if test x"$have_qt4" = xyes; then

    # Find moc (Meta Object Compiler).
    AC_PATH_PROGS([QT4_MOC], [moc], [missing], [$QT4_PATH:$PATH])
    if test x"$QT4_MOC" = xmissing; then
      AC_MSG_ERROR([Cannot find moc (Meta Object Compiler) in your PATH. Try using --with-qt4.])
    fi

    # Find uic (User Interface Compiler).
    AC_PATH_PROGS([QT4_UIC], [uic], [missing], [$QT4_PATH:$PATH])
    if test x"$UIC" = xmissing; then
      AC_MSG_ERROR([Cannot find uic (User Interface Compiler) in your PATH. Try using --with-qt4.])
    fi

    # Find rcc (Qt4 Resource Compiler).
    AC_PATH_PROGS([QT4_RCC], [rcc], [false], [$QT4_PATH:$PATH])
    if test x"$UIC" = xfalse; then
      AC_MSG_WARN([Cannot find rcc (Qt4 Resource Compiler) in your PATH. Try using --with-qt4.])
    fi


    have_qt4=no
    # Get ready to build a test-app with Qt4.
    if mkdir conftest.dir && cd conftest.dir; then :; else
      AC_MSG_ERROR([Cannot mkdir conftest.dir or cd to that directory.])
    fi
    cat >conftest.h <<_ASEOF
#include <QObject>

class Foo: public QObject
{
  Q_OBJECT;
public:
  Foo();
  ~Foo() {}
public slots:
  void setValue(int value);
signals:
  void valueChanged(int newValue);
private:
  int value_;
};
_ASEOF

    cat >conftest.cpp <<_ASEOF
#include "conftest.h"
Foo::Foo()
  : value_ (42)
{
  connect(this, SIGNAL(valueChanged(int)), this, SLOT(setValue(int)));
}

void Foo::setValue(int value)
{
  value_ = value;
}

int main()
{
  Foo f;
}
_ASEOF
    if $QMAKE -project; then :; else
      AC_MSG_ERROR([Calling $QMAKE -project failed.])
    fi

    # Find the .pro file generated by qmake.
    pro_file='conftest.dir.pro'
    test -f $pro_file || pro_file=`echo *.pro`
    if test -f "$pro_file"; then :; else
      AC_MSG_ERROR([Can't find the .pro file generated by Qmake.])
    fi

dnl Tweak the value of QT in the .pro if have been the 1st arg.
m4_ifval([$1], [_AT_TWEAK_PRO_FILE([QT], [$1])])

dnl Tweak the value of CONFIG in the .pro if have been given a 2nd arg.
m4_ifval([$2], [_AT_TWEAK_PRO_FILE([CONFIG], [$2])])

m4_ifval([$3],
[ # Add the extra-settings the user wants to set in the .pro
  echo "$3" >>"$pro_file"
])

    echo "$as_me:$LINENO: Invoking $QMAKE on $pro_file" >&AS_MESSAGE_LOG_FD
    sed 's/^/| /' "$pro_file" >&AS_MESSAGE_LOG_FD

    if $QMAKE; then :; else
      AC_MSG_ERROR([Calling $QMAKE failed.])
    fi
    # Try to compile a simple Qt4 app.
    AC_CACHE_CHECK([whether we can build a simple Qt4 app], [at_cv_qt4_build],
    [at_cv_qt4_build=ko
    : ${MAKE=make}

    if $MAKE >&AS_MESSAGE_LOG_FD 2>&1; then
      at_cv_qt4_build='ok, looks like Qt 4'
      have_qt4=yes
    else
      echo "$as_me:$LINENO: Build failed, trying to #include <qobject.h> \
instead" >&AS_MESSAGE_LOG_FD
      sed 's/<QObject>/<qobject.h>/' conftest.h > tmp.h && mv tmp.h conftest.h
      if $MAKE >&AS_MESSAGE_LOG_FD 2>&1; then
        at_cv_qt4_build='ok, looks like Qt 3'
      else
        # Sometimes (such as on Debian) build will fail because Qt4 hasn't been
        # installed in debug mode and qmake tries (by default) to build apps in
        # debug mode => Try again in release mode.
        echo "$as_me:$LINENO: Build failed, trying to enforce release mode" \
              >&AS_MESSAGE_LOG_FD

        _AT_TWEAK_PRO_FILE([CONFIG], [+release])

        sed 's/<qobject.h>/<QObject>/' conftest.h > tmp.h && mv tmp.h conftest.h
        if $MAKE >&AS_MESSAGE_LOG_FD 2>&1; then
          at_cv_qt4_build='ok, looks like Qt 4, release mode forced'
          have_qt4=yes
        else
          echo "$as_me:$LINENO: Build failed, trying to #include <qobject.h> \
instead" >&AS_MESSAGE_LOG_FD
          sed 's/<QObject>/<qobject.h>/' conftest.h > tmp.h && mv tmp.h conftest.h
          if $MAKE >&AS_MESSAGE_LOG_FD 2>&1; then
            at_cv_qt4_build='ok, looks like Qt 3, release mode forced'
          else
            at_cv_qt4_build=ko
            echo "$as_me:$LINENO: failed program was:" >&AS_MESSAGE_LOG_FD
            sed 's/^/| /' conftest.h >&AS_MESSAGE_LOG_FD
            echo "$as_me:$LINENO: failed program was:" >&AS_MESSAGE_LOG_FD
            sed 's/^/| /' conftest.cpp >&AS_MESSAGE_LOG_FD
          fi # if make with Qt3-style #include and release mode forced.
        fi # if make with Qt4-style #include and release mode forced.
      fi # if make with Qt3-style #include.
    fi # if make with Qt4-style #include.
    ])dnl end: AC_CACHE_CHECK(at_cv_qt4_build)

    if test x"$at_cv_qt4_build" = xko; then
      AC_MSG_ERROR([Cannot build a test Qt4 program])
    fi
    QT4_VERSION_MAJOR=`echo "$at_cv_qt4_build" | sed 's/^[^0-9]*//'`
    AC_SUBST([QT4_VERSION_MAJOR])

    # This sed filter is applied after an expression of the form: /^FOO.*=/!d;
    # It starts by removing the beginning of the line, removing references to
    # SUBLIBS, removing unnecessary whitespaces at the beginning, and prefixes
    # all variable uses by QT4_.
    qt4_sed_filter='s///;
                   s/$(SUBLIBS)//g;
                   s/^ *//;
                   s/\$(\(@<:@A-Z_@:>@@<:@A-Z_@:>@*\))/$(QT4_\1)/g'

    # Find the Makefile (qmake happens to generate a fake Makefile which invokes
    # a Makefile.Debug or Makefile.Release). We we have both, we'll pick the
    # Makefile.Release. The reason is that the main difference is that release
    # uses -Os and debug -g. We can override -Os by passing another -O but we
    # usually don't override -g.
    if test -f Makefile.Release; then
      at_mfile='Makefile.Release'
    else
      at_mfile='Makefile'
    fi
    if test -f $at_mfile; then :; else
      AC_MSG_ERROR([Cannot find the Makefile generated by qmake.])
    fi

    # Find the DEFINES of Qt4 (should have been named CPPFLAGS).
    AC_CACHE_CHECK([for the DEFINES to use with Qt4], [at_cv_env_QT4_DEFINES],
    [at_cv_env_QT4_DEFINES=`sed "/^DEFINES@<:@^A-Z@:>@*=/!d;$qt4_sed_filter" $at_mfile`])
    AC_SUBST([QT4_DEFINES], [$at_cv_env_QT4_DEFINES])

    # Find the CFLAGS of Qt4 (We can use Qt4 in C?!)
    AC_CACHE_CHECK([for the CFLAGS to use with Qt4], [at_cv_env_QT4_CFLAGS],
    [at_cv_env_QT4_CFLAGS=`sed "/^CFLAGS@<:@^A-Z@:>@*=/!d;$qt4_sed_filter" $at_mfile`])
    AC_SUBST([QT4_CFLAGS], [$at_cv_env_QT4_CFLAGS])

    # Find the CXXFLAGS of Qt4.
    AC_CACHE_CHECK([for the CXXFLAGS to use with Qt4], [at_cv_env_QT4_CXXFLAGS],
    [at_cv_env_QT4_CXXFLAGS=`sed "/^CXXFLAGS@<:@^A-Z@:>@*=/!d;$qt4_sed_filter" $at_mfile`])
    AC_SUBST([QT4_CXXFLAGS], [$at_cv_env_QT4_CXXFLAGS])

    # Find the INCPATH of Qt4.
    AC_CACHE_CHECK([for the INCPATH to use with Qt4], [at_cv_env_QT4_INCPATH],
    [at_cv_env_QT4_INCPATH=`sed "/^INCPATH@<:@^A-Z@:>@*=/!d;$qt4_sed_filter" $at_mfile`])
    AC_SUBST([QT4_INCPATH], [$at_cv_env_QT4_INCPATH])

    AC_SUBST([QT4_CPPFLAGS], ["$at_cv_env_QT4_DEFINES $at_cv_env_QT4_INCPATH"])

    # Find the LFLAGS of Qt4 (Should have been named LDFLAGS)
    AC_CACHE_CHECK([for the LDFLAGS to use with Qt4], [at_cv_env_QT4_LDFLAGS],
    [at_cv_env_QT4_LDFLAGS=`sed "/^LFLAGS@<:@^A-Z@:>@*=/!d;$qt4_sed_filter" $at_mfile`])
    AC_SUBST([QT4_LFLAGS], [$at_cv_env_QT4_LDFLAGS])
    AC_SUBST([QT4_LDFLAGS], [$at_cv_env_QT4_LDFLAGS])

    AC_MSG_CHECKING([whether host operating system is Darwin])
    at_darwin="no"
    case $host_os in
      darwin*)
        at_darwin="yes"
        ;;
    esac
    AC_MSG_RESULT([$at_darwin])

    # Find the LIBS of Qt4.
    AC_CACHE_CHECK([for the LIBS to use with Qt4], [at_cv_env_QT4_LIBS],
    [at_cv_env_QT4_LIBS=`sed "/^LIBS@<:@^A-Z@:>@*=/!d;$qt4_sed_filter" $at_mfile`
     if test x$at_darwin = xyes; then
       # Fix QT4_LIBS: as of today Libtool (GNU Libtool 1.5.23a) doesn't handle
       # -F properly. The "bug" has been fixed on 22 October 2006
       # by Peter O'Gorman but we provide backward compatibility here.
       at_cv_env_QT4_LIBS=`echo "$at_cv_env_QT4_LIBS" \
                               | sed 's/^-F/-Wl,-F/;s/ -F/ -Wl,-F/g'`
     fi
    ])
    AC_SUBST([QT4_LIBS], [$at_cv_env_QT4_LIBS])

    cd .. && rm -rf conftest.dir
  fi
  #########################################################
])

# AT_REQUIRE_QT4_VERSION(QT4_version)
# ---------------------------------
# Check (using qmake) that Qt's version "matches" QT4_version.
# Must be run AFTER AT_WITH_QT4. Requires autoconf 2.60.
AC_DEFUN([AT_REQUIRE_QT4_VERSION],
[ AC_PREREQ([2.60])
  if test x"$QMAKE" = x; then
    AC_MSG_ERROR([\$QMAKE is empty. \
Did you invoke AT@&t@_WITH_QT4 before AT@&t@_REQUIRE_QT4_VERSION?])
  fi
  AC_CACHE_CHECK([for Qt4's version], [at_cv_QT4_VERSION],
  [echo "$as_me:$LINENO: Running $QMAKE --version:" >&AS_MESSAGE_LOG_FD
  $QMAKE --version >&AS_MESSAGE_LOG_FD
  at_cv_QT4_VERSION=`$QMAKE --version | sed '1d; s/.*version *//;
                                            s/\(@<:@0-9.@:>@*\).*/\1/'`])
  if test x"$at_cv_QT4_VERSION" = x; then
    AC_MSG_ERROR([Cannot detect Qt4's version.])
  fi
  AC_SUBST([QT4_VERSION], [$at_cv_QT4_VERSION])
  AS_VERSION_COMPARE([$QT4_VERSION], [$1],
    [AC_MSG_ERROR([This package requires Qt4 $1 or above.])])
])

# _AT_TWEAK_PRO_FILE(QT_VAR, VALUE)
# ---------------------------
# @internal. Tweak the variable QT_VAR in the .pro.
# VALUE is an IFS-separated list of value and each value is rewritten
# as follows:
#   +value  => QT_VAR += value
#   -value  => QT_VAR -= value
#    value  => QT_VAR += value
AC_DEFUN([_AT_TWEAK_PRO_FILE],
[ # Tweak the value of $1 in the .pro file for $2.

  qt_conf=''
  for at_mod in $2; do
    at_mod=`echo "$at_mod" | sed 's/^-//; tough
                                  s/^+//; beef
                                  :ough
                                  s/^/$1 -= /;n
                                  :eef
                                  s/^/$1 += /'`
    qt_conf="$qt_conf
$at_mod"
  done
  echo "$qt_conf" | sed 1d >>"$pro_file"
])