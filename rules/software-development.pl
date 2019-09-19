hasSource(devRule1,'TESTS

	 ShinyCMS has very poor test coverage.  If you would like to improve this, your
	 contributions will be very gratefully received!  At minimum, please don''t make
	 it worse... if you add a new controller, add a minimal test file for it too.').

hasSource(devRule1,'At minimum, please don''t make it worse... if you add a new controller, add a minimal test file for it too.').

rule(devRules1,
     desires(Developer,
	     and(
		 create(Developer,File),
		 isa(File,testFile),
		 testFor(File,X))),
     (create(Developer,X),
      isa(X,shinyCMSController))).
