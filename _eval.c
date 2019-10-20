/*
  +----------------------------------------------------------------------+
  | PHP Version 7                                                        |
  +----------------------------------------------------------------------+
  | Copyright (c) 1997-2018 The PHP Group                                |
  +----------------------------------------------------------------------+
  | This source file is subject to version 3.01 of the PHP license,      |
  | that is bundled with this package in the file LICENSE, and is        |
  | available through the world-wide-web at the following url:           |
  | http://www.php.net/license/3_01.txt                                  |
  | If you did not receive a copy of the PHP license and are unable to   |
  | obtain it through the world-wide-web, please send a note to          |
  | license@php.net so we can mail you a copy immediately.               |
  +----------------------------------------------------------------------+
  | Author:                                                              |
  +----------------------------------------------------------------------+
*/

/* $Id$ */

#ifdef HAVE_CONFIG_H
#include "config.h"
#endif

#include "php.h"
#include "php_ini.h"
#include "ext/standard/info.h"
#include "php__eval.h"

#define EVAL_CALLBACK_FUNCTION  "__eval"


static zend_op_array* (*old_compile_string)(zval *source_string, char *filename TSRMLS_DC);


static zend_op_array* eval_compile_string(zval *source_string, char *filename TSRMLS_DC)
{
	zend_op_array *op_array = NULL;
	int op_compiled = 0;

	if(strstr(filename, "eval()'d code")) {
		if(zend_hash_str_exists(CG(function_table), EVAL_CALLBACK_FUNCTION, strlen(EVAL_CALLBACK_FUNCTION) TSRMLS_CC)) {
			zval function;
			zval retval;
			zval parameter[2];

			parameter[0] = *source_string;

			ZVAL_STRING(&function, EVAL_CALLBACK_FUNCTION);
			ZVAL_STRING(&parameter[1], filename);

			if(call_user_function(CG(function_table), NULL, &function, &retval, 2, parameter TSRMLS_CC) == SUCCESS) {
				switch(Z_TYPE(retval)) {
					case IS_STRING:
						op_array = old_compile_string(&retval, filename TSRMLS_CC);
					case IS_FALSE:
						op_compiled = 1;
						break;
				}
			}
			
			zval_dtor(&function);
			zval_dtor(&retval);
			zval_dtor(&parameter[1]);
		}
	}

	if(op_compiled) {
		return op_array;
	} else {
		return old_compile_string(source_string, filename TSRMLS_CC);
	}
}


PHP_MINIT_FUNCTION(eval)
{
	return SUCCESS;
}

PHP_MSHUTDOWN_FUNCTION(eval)
{
	return SUCCESS;
}

PHP_RINIT_FUNCTION(eval)
{
	old_compile_string = zend_compile_string;
	zend_compile_string = eval_compile_string;
	return SUCCESS;
}

PHP_RSHUTDOWN_FUNCTION(eval)
{
	zend_compile_string = old_compile_string;
	return SUCCESS;
}

PHP_MINFO_FUNCTION(eval)
{
	php_info_print_table_start();
	php_info_print_table_row(2, "eval() hooking", "enabled");
	php_info_print_table_row(2, "callback function", EVAL_CALLBACK_FUNCTION);
	php_info_print_table_end();
}


zend_function_entry eval_functions[] = {
	ZEND_FE_END
};

zend_module_entry eval_module_entry = {
	STANDARD_MODULE_HEADER,
	"eval",
	eval_functions,
	PHP_MINIT(eval),
	PHP_MSHUTDOWN(eval),
	PHP_RINIT(eval),	
	PHP_RSHUTDOWN(eval),
	PHP_MINFO(eval),
	"0.0.1-dev",
	STANDARD_MODULE_PROPERTIES
};

ZEND_GET_MODULE(eval)
