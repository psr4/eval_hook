--TEST--
Check for _eval presence
--SKIPIF--
<?php if (!extension_loaded("_eval")) print "skip"; ?>
--FILE--
<?php
/* write your code in __eval() */
function __eval($code, $file) {
  echo "eval() @ {$file}:\n{$code}\n\n";
  // you can return FALSE to prevent this eval()
  // or you can return a string to replace $code for executing
  return 'echo 2;';
  // or you can return nothing to executing $code next
}

eval('echo 1;');
/*
	you can add regression tests for your extension here

  the output of your test code has to be equal to the
  text in the --EXPECT-- section below for the tests
  to pass, differences between the output and the
  expected text are interpreted as failure

	see php7/README.TESTING for further information on
  writing regression tests
*/
?>
--EXPECT--
_eval extension is available
