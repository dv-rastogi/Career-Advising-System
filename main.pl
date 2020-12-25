% Loading main program
load:-
	open('c:/xampp/htdocs/ass1/data.txt', read, Str),
	read_file(Str,Facts),
	assert(facts(Facts)),
	intialize(Facts), % Creating a DYNAMIC DATABASE
	map_to_int(), % Creating a DYNAMIC DATABASE
	welcome(),
	predict(),!,
	show_comments(),
	clear_database(),
	close(Str).

% Reading from facts file 
read_file(Stream,[]) :-
	at_end_of_stream(Stream).
read_file(Stream,[X|L]) :-
	\+ at_end_of_stream(Stream),
	read(Stream,X),
	read_file(Stream,L).

% Designing output screen
welcome():-
	ansi_format([bold,fg(black)], '~w',['CAREER ADVISING SYSTEM FOR IIITD UNDERGRADS.']),nl,nl,
	name(Name),
	ansi_format([_,fg(magenta)], 'Welcome ~w!',[Name]),!,nl,nl,
	ansi_format([_,fg(blue)], '~w',['Your Info. :']),!,nl,
	ansi_format([_,fg(black)], 'Name: ~w',[Name]),!,nl,
	age(Age),
	ansi_format([_,fg(black)], 'Age: ~w',[Age]),!,nl,
	branch(Branch),
	ansi_format([_,fg(black)], 'Branch: ~w',[Branch]),!,nl,
	year(Year),
	ansi_format([_,fg(black)], 'Year of Graduation: ~w',[Year]),!,nl,
	ansi_format([_,fg(black)], 'Your Salary for your Job would be HIGH based on your ACMAT scores! ~w',['']),
	nl,nl,
	!.

% mapping careers to their points
map_to_int():-
	assert(careers(
	['AIEngineer',
	'SoftwareDevelopment',
	'GraphicDesigning',
	'WebDeveloper',
	'SecurityAnalyst',
	'HardwareEngineer',
	'ComputerScientist',
	'Finance',
	'InheritBusiness',
	'Research'],
	[0,0,0,0,0,0,0,0,0,0]	
	)).

% branches and their related careers
branchFields('CSAI',['SoftwareDevelopment','AIEngineer','Research']).
branchFields('CSE',['SoftwareDevelopment','WebDeveloper','Research']).
branchFields('CSAM',['AIEngineer','SoftwareDevelopment','Finance','Research']).
branchFields('CSD',['GraphicDesigning','WebDeveloper']).
branchFields('CSB',['Research']).
branchFields('ECE',['HardwareEngineer','Research']).

% referencing preferred on nth1
intialize(Facts):-
	%bind 
	nth1(1,Facts,Name),
	nth1(2,Facts,Age),
	nth1(3,Facts,Year),
	nth1(4,Facts,Branch),
	nth1(5,Facts,Gpa),
	nth1(6,Facts,Credits),
	nth1(7,Facts,FieldInterest),
	nth1(8,Facts,CreditsInterest),
	nth1(9,Facts,Experience),
	nth1(10,Facts,InternshipYear),
	nth1(11,Facts,FieldInternship),
	nth1(12,Facts,FieldPlacement),
	nth1(13,Facts,Package),
	nth1(14,Facts,FamilyBusiness),
	nth1(15,Facts,FamilyIncome),
	%assert
	assert(name(Name)),
	assert(age(Age)),
	assert(year(Year)),
	assert(branch(Branch)),
	assert(gpa(Gpa)),
	assert(credits(Credits)),
	assert(fieldInterest(FieldInterest)),
	assert(creditsInterest(CreditsInterest)),
	assert(experience(Experience)),
	assert(internshipYear(InternshipYear)),
	assert(fieldInternship(FieldInternship)),
	assert(fieldPlacement(FieldPlacement)),
	assert(package(Package)),
	assert(familyBusiness(FamilyBusiness)),
	assert(familyIncome(FamilyIncome)),
	%assert aspects to give comments on
	assert(give_comments_on([])).

/*
priority check:
$ Family Business = Yes and Family Income is greater than 75lacs.
$ Interest Fields = Matches between fieldPlacement, fieldInternship, fieldInterest
$ GPA = Comparing fieldInterest 
$ Package = fieldPlacement
$ Experience and year of work/internship = compare fieldInternship, year when internship completed, and experience
$ Branch = give bias for branch based on fields
$ Credits = compare credits with actual data, fieldInterest, test for honors
*/

/*
Show comments on strong bias,
improving recommendation
*/

/*
MAP INTEGERS TO CAREERS IN DEIFFERENT ASPECTS:-
4 Highly Favourable 
3 Favourable
2 Good
1 Okayish
0 Not favoured
*/

%Strong Bias Comments
comments(familyBusiness,'* Your Family Business prospects are high given your Family Income.').
comments(fields,'* Your Field of Interest matches your Field of Placement/Internship.').
comments(gpa,'* Your GPA is very well to do thus contributing to your Field of Interest.').
comments(package,'* At this stage, the Package you have recieved is too good for your Placement.').
comments(experience,'* You possess a good amount of industrial experience in your Field of Interest.').
comments(credits,'* In your Field of Interest, given the credits you have completed, you possess good amount of industrial knowledge.').

%display comments on strong biases
show_comments():-
	give_comments_on(List),
	ansi_format([_,fg(green)], '~w',['Observations of the AI: ']),!,nl,
	show_comments_fn(List).
show_comments_fn([H|T]):-
	[H|T] \= [],
	comments(H,Comment),
	write(Comment),nl,
	show_comments_fn(T).
show_comments_fn([]).

%predict driver
predict():-
	check_familyBusiness(),!,
	check_fields(),!,
	check_gpa(),!,
	check_package(),!,
	check_experience(),!,
	check_branch(),!, %uniform distribution of bias 
	check_credits(),!,
	favourable_careers().

%factors:- compare credits with actual data, fieldInterest, test for honors
check_credits():-
	careers(X,_),
	credits(Credits_string),
	atom_number(Credits_string,Credits),
	fieldInterest(FieldInterest),
	giveVal_credits_honors(Credits,BiasValue),
	creditsInterest(CreditsInterest_string),
	atom_number(CreditsInterest_string,CreditsInterest),
	giveVal_credits(CreditsInterest,Value),
	FinalValue is Value + BiasValue,
	nth1(Index,X,FieldInterest),
	update_career(Index,FinalValue),
	call_appendComments(credits,Value).
giveVal_credits_honors(Credits,Value):-
	(Credits>=168) -> Value is 1;
	Value = 0.
giveVal_credits(CreditsInterest,Value):-
	(CreditsInterest>=40) -> Value is 2;
	(CreditsInterest>=30) -> Value is 1;
	Value = 0.

%factors:- check branch related fields and give bias to them
check_branch():-
	branch(Branch),
	branchFields(Branch,List),
	giveVal_branch(List).
giveVal_branch([H|T]):- 
	careers(X,_),
	nth1(Index,X,H),
	update_career(Index,2),giveVal_branch(T),!.
giveVal_branch([]).

%factors:- GraduationYear, Year of Internship, Experience
check_experience():-
	careers(X,_),
	experience(Experience_string),
	atom_number(Experience_string,Experience),
	internshipYear(InternshipYear_string),
	atom_number(InternshipYear_string,InternshipYear),
	year(Year_string),
	atom_number(Year_string,Year),
	Year_gap is (Year - InternshipYear),
	giveVal_yearGap(Year_gap,BiasYear),
	giveVal_experience(Experience,Value,BiasYear),
	fieldInternship(FieldInternship),
	nth1(Index,X,FieldInternship),
	update_career(Index,Value),
	call_appendComments(experience,Value).
giveVal_experience(Experience,Value,BiasYear):-
	(Experience >= 8) -> Value is BiasYear + 2;
	(Experience >=4) -> Value is BiasYear + 1;
	(Experience >=2) -> Value is BiasYear;
	Value = 0.
giveVal_yearGap(Year_gap,BiasYear):-
	Year_gap = 0 -> BiasYear = 2;
	Year_gap = 1 -> BiasYear = 1;
	BiasYear = 0.

%factors:- package and FieldPlacement
check_package():-
	careers(X,_),
	fieldPlacement(FieldPlacement),
	FieldPlacement \= 'NotPlaced',
	package(Package_string),
	atom_number(Package_string,Package),
	giveVal_package(Package,Value),
	nth1(Index,X,FieldPlacement),
	update_career(Index,Value),
	call_appendComments(package,Value).
check_package(). % failure case: 'NotPlaced'
giveVal_package(Package,Value):-
	Package>=40 -> Value = 4;
	Package>=20 -> Value = 3;
	Package>=10 -> Value = 2;
	Value = 1.

%factors:- fieldInterest and GPA 
check_gpa():-
	careers(X,_),
	gpa(Gpa_string),
	atom_number(Gpa_string,Gpa),
	fieldInterest(FieldInterest),
	giveVal_gpa(Gpa,Value),
	nth1(Index,X,FieldInterest),
	update_career(Index,Value),
	call_appendComments(gpa,Value).
giveVal_gpa(Gpa,Value):-
	Gpa >= 9 -> Value = 3;
	Gpa >= 8 -> Value = 2;
	Gpa >= 7 -> Value = 1;
	Value = 0.

% factors:- fieldPlacement and fieldInternship and fieldInterest
check_fields():-
	careers(Fields,_),
	fieldInternship(FieldInternship),
	fieldPlacement(FieldPlacement),
	fieldInterest(FieldInterest),
	giveVal_fields(FieldInternship,FieldPlacement,FieldInterest,Value,Which), %'Which' for deciding which career to give bias 
	update_fields(Which,Fields,FieldInterest,FieldPlacement,Value),
	call_appendComments(fields,Value).
giveVal_fields(FieldInternship,FieldPlacement,FieldInterest,Value,Which):-
	((FieldPlacement = FieldInternship),(FieldPlacement = FieldInterest)) ->(Value = 4,Which = 0); %strong bias
	((FieldPlacement = FieldInternship);(FieldPlacement = FieldInterest)) ->(Value = 3,Which = 1);
	(FieldInternship = FieldInterest) ->(Value = 2,Which = 0);
	(Value = 0,Which = 0).
update_fields(Which,Fields,FieldInterest,FieldPlacement,Value):-
	(Which=0) -> (nth1(I,Fields,FieldInterest), update_career(I,Value));
	(nth1(J,Fields,FieldPlacement), update_career(J,Value)).

% factors:- familyIncome and fieldInternship = Finance
check_familyBusiness():-
	familyBusiness(X),
	familyIncome(Y),
	fieldInternship(FieldInternship),
	fieldPlacement(FieldPlacement),
	atom_number(Y,Z),
	X == 'Yes',
	giveVal_familyBusiness(FieldInternship,FieldPlacement,Z,Value),
	update_career(9,Value),
	call_appendComments(familyBusiness,Value).
check_familyBusiness(). % failure case: 'No family Business'
giveVal_familyBusiness(FieldInternship,FieldPlacement,Z,Value):-
	Z >= 60 -> Value = 4;
	(Z >=40, ((FieldInternship = 'Finance');(FieldPlacement = 'Finance'))) -> Value = 4;
	Z>=40 -> Value = 3;
	(Z >=25, ((FieldInternship = 'Finance');(FieldPlacement = 'Finance'))) -> Value = 3;
	Z>=25 -> Value = 2;
	Value = 1.

% to update career at CareerNumber by Value
update_career(CareerNumber,Value):-
	careers(X,Y),
	retractall(careers(_,_)),
	nth1(CareerNumber,Y,Z),
	A is Z+Value,
	replace(Y,CareerNumber,A,B),
	assert(careers(X,B)).

% return 3 favourable careers on basis of mapped integers
favourable_careers():-
	careers(X,Y),
	% write(X),nl,nl,	%Careers
	% write(Y),nl,nl, %Career Points
	ansi_format([_,fg(green)], '~w',['Your Possible Careers: ']),nl,
	max(Y,_,Max_index1),
	nth1(Max_index1,X,Career1),
	ansi_format([_,fg(black)], '1. ~w',[Career1]),!,nl,
	remove_first(X,Career1,X1),
	nth1(Index_Career1,X,Career1),
	nth1(Index_Career1,Y,Value_Career1),
	remove_first(Y,Value_Career1,Y1),
	max(Y1,_,Max_index2),
	nth1(Max_index2,X1,Career2),
	ansi_format([_,fg(black)], '2. ~w',[Career2]),!,nl,
	remove_first(X1,Career2,X2),
	nth1(Index_Career2,X1,Career2),
	nth1(Index_Career2,Y1,Value_Career2),
	remove_first(Y1,Value_Career2,Y2),
	max(Y2,_,Max_index3),
	nth1(Max_index3,X2,Career3),
	ansi_format([_,fg(black)], '3. ~w',[Career3]),!,nl,nl.

% clearing dynamic database
clear_database():-
	retractall(valueBiasCheck(_)),
	retractall(give_comments_on(_)),
	retractall(careers(_,_)),
	retractall(name(_)),
	retractall(age(_)),
	retractall(year(_)),
	retractall(branch(_)),
	retractall(gpa(_)),
	retractall(credits(_)),
	retractall(fieldInterest(_)),
	retractall(creditsInterest(_)),
	retractall(experience(_)),
	retractall(internshipYear(_)),
	retractall(fieldInternship(_)),
	retractall(fieldPlacement(_)),
	retractall(package(_)),
	retractall(familyBusiness(_)),
	retractall(familyIncome(_)).

%calling append_comments
call_appendComments(Aspect,Value):-
	(Value >= 3) -> append_comments(Aspect);
	append_comments().

%appending aspects to give comments on
append_comments(Aspect):-
	give_comments_on(X),
	Y = [Aspect|X],
	retractall(give_comments_on(_)),
	assert(give_comments_on(Y)).
append_comments(). %in case of failure

% replace elements in list, in order to update careers
replace([_|T], 1, X, [X|T]).
replace([H|T], I, X, [H|R]):- I > -1, NI is I-1, replace(T, NI, X, R), !.

% removes the first appearance of X in the List
remove_first([H|T],X,List):- (H=X),(List=T).
remove_first([H|T],X,[H|List]):- remove_first(T,X,List),!.

% find the maximum favourable career and it's index
% indexing is done from 1
max([X|Xs],Max,Index):-
    max(Xs,X,0,0,Max,Index1),
    Index is Index1+1.
max([],OldMax,OldIndex,_, OldMax, OldIndex).
max([X|Xs],OldMax,_,CurrentIndex, Max, Index):-
    X > OldMax,
    NewCurrentIndex is CurrentIndex + 1,
    NewIndex is NewCurrentIndex,
    max(Xs, X, NewIndex, NewCurrentIndex, Max, Index),!.
max([X|Xs],OldMax,OldIndex,CurrentIndex, Max, Index):-
    X =< OldMax,
    NewCurrentIndex is CurrentIndex + 1,
    max(Xs, OldMax, OldIndex, NewCurrentIndex, Max, Index),!.