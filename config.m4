dnl $Id$
dnl config.m4 for extension _eval

dnl Comments in this file start with the string 'dnl'.
dnl Remove where necessary. This file will not work
dnl without editing.

dnl If your extension references something external, use with:

PHP_ARG_WITH(_eval, for _eval support,
Make sure that the comment is aligned:
[  --with-_eval             Include _eval support])

dnl Otherwise use enable:

PHP_ARG_ENABLE(_eval, whether to enable _eval support,
dnl Make sure that the comment is aligned:
[  --enable-_eval           Enable _eval support])

if test "$PHP__EVAL" != "no"; then
  dnl Write more examples of tests here...

  dnl # get library FOO build options from pkg-config output
  dnl AC_PATH_PROG(PKG_CONFIG, pkg-config, no)
  dnl AC_MSG_CHECKING(for libfoo)
  dnl if test -x "$PKG_CONFIG" && $PKG_CONFIG --exists foo; then
  dnl   if $PKG_CONFIG foo --atleast-version 1.2.3; then
  dnl     LIBFOO_CFLAGS=`$PKG_CONFIG foo --cflags`
  dnl     LIBFOO_LIBDIR=`$PKG_CONFIG foo --libs`
  dnl     LIBFOO_VERSON=`$PKG_CONFIG foo --modversion`
  dnl     AC_MSG_RESULT(from pkgconfig: version $LIBFOO_VERSON)
  dnl   else
  dnl     AC_MSG_ERROR(system libfoo is too old: version 1.2.3 required)
  dnl   fi
  dnl else
  dnl   AC_MSG_ERROR(pkg-config not found)
  dnl fi
  dnl PHP_EVAL_LIBLINE($LIBFOO_LIBDIR, _EVAL_SHARED_LIBADD)
  dnl PHP_EVAL_INCLINE($LIBFOO_CFLAGS)

  dnl # --with-_eval -> check with-path
  dnl SEARCH_PATH="/usr/local /usr"     # you might want to change this
  dnl SEARCH_FOR="/include/_eval.h"  # you most likely want to change this
  dnl if test -r $PHP__EVAL/$SEARCH_FOR; then # path given as parameter
  dnl   _EVAL_DIR=$PHP__EVAL
  dnl else # search default path list
  dnl   AC_MSG_CHECKING([for _eval files in default path])
  dnl   for i in $SEARCH_PATH ; do
  dnl     if test -r $i/$SEARCH_FOR; then
  dnl       _EVAL_DIR=$i
  dnl       AC_MSG_RESULT(found in $i)
  dnl     fi
  dnl   done
  dnl fi
  dnl
  dnl if test -z "$_EVAL_DIR"; then
  dnl   AC_MSG_RESULT([not found])
  dnl   AC_MSG_ERROR([Please reinstall the _eval distribution])
  dnl fi

  dnl # --with-_eval -> add include path
  dnl PHP_ADD_INCLUDE($_EVAL_DIR/include)

  dnl # --with-_eval -> check for lib and symbol presence
  dnl LIBNAME=_eval # you may want to change this
  dnl LIBSYMBOL=_eval # you most likely want to change this 

  dnl PHP_CHECK_LIBRARY($LIBNAME,$LIBSYMBOL,
  dnl [
  dnl   PHP_ADD_LIBRARY_WITH_PATH($LIBNAME, $_EVAL_DIR/$PHP_LIBDIR, _EVAL_SHARED_LIBADD)
  dnl   AC_DEFINE(HAVE__EVALLIB,1,[ ])
  dnl ],[
  dnl   AC_MSG_ERROR([wrong _eval lib version or lib not found])
  dnl ],[
  dnl   -L$_EVAL_DIR/$PHP_LIBDIR -lm
  dnl ])
  dnl
  dnl PHP_SUBST(_EVAL_SHARED_LIBADD)

  PHP_NEW_EXTENSION(_eval, _eval.c, $ext_shared,, -DZEND_ENABLE_STATIC_TSRMLS_CACHE=1)
fi
