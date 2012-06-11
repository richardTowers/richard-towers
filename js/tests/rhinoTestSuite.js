/*
 * Based on: http://twoguysarguing.wordpress.com/2010/11/02/make-javascript-tests-part-of-your-build-qunit-rhino/
 * Run with java -jar js.jar rhinoTestSuite.js
 */

load("qunit-git.js");

QUnit.init();
QUnit.config.blocking = false;
QUnit.config.autorun = true;
QUnit.config.updateRate = 0;
QUnit.log = function(result) {
    print(result ? 'PASS' : 'FAIL', result.message);
};

load("exampleLibrary.js");
load("exampleTests.js");