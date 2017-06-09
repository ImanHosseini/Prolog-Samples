%membership. named such that there is no naming conflict with native member/2
ismem( X, [X|Tail]).
ismem(X, [Head | Tail]) :- ismem(X, Tail).


%utilizing diff list for appending
%apend(X-Y,Y-Z,X-Z).
apend([], List, List).
apend([X|List1], List2, [X|List3]):-
 apend(List1, List2, List3).




match( X, [Y] ) :- ismem(Y, X).



match(plus(R) , X):- match(R, X).
match(plus(R), X) :-
	apend(X1, X2, X),
    match( R,X1 ) , match( plus(R), X2).
	

match(union(R1, R2), X) :-
	match(R1, X).
	
match(union(R1, R2), X) :-
	match(R2, X).	

match(count( R, 0 ,Upper ) , []).
match(count(R, 0 , Upper ) , X):-
	apend(X1,X2,X),
	match( R, X1),
	Upper > 0,
	Upper2 is Upper-1,
	match(count(R, 0, Upper2), X2).
	 %concatenation rule
match(concat(R1, R2), X) :- 
apend(X1, X2, X),
match(R1, X1) ,
match(R2, X2).

%star rule
match(star(R) , []).
match(star(R), X) :-
	apend(X1, X2, X),
    match( star(R), X2),match( R,X1 )  .


match(optional(R) , []).
match(optional(R), X) :-
  match( R, X).

%recursive low-high	 
match(count(R, Lower, Upper), X) :-
	apend(X1, X2,X), 
	match( R , X1),
	Lower > 0,
	Lower2 is Lower-1,
	Upper2 is Upper-1, 
	match( count( R, Lower2 , Upper2), X2).
