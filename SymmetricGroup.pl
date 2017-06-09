element_at(X,[X|_],1).
element_at(X,[_|L],K) :- element_at(X,L,K1), K is K1 + 1.


list_length([]     , 0 ).
list_length([_|Xs] , L ) :- list_length(Xs,N) , L is N+1 .

is_set(Lst) :-
    setof(X, member(X, Lst), Set),
    length(Lst, N),
    length(Set, N),my_max(Lst,N),minimo(Lst,1).

	add_at_end(E, [], [E]).
add_at_end(E, [H|T], [H|Tnew]) :- add_at_end(E, T, Tnew).

my_max([], R, R). %end
my_max([X|Xs], WK, R):- X >  WK, my_max(Xs, X, R). %WK is Carry about
my_max([X|Xs], WK, R):- X =< WK, my_max(Xs, WK, R).
my_max([X|Xs], R):- my_max(Xs, X, R). %start	

minimo([X], X) :- !.
minimo([X,Y|Tail], N):-
    ( X > Y ->
        minimo([Y|Tail], N)
    ;
        minimo([X|Tail], N)
    ).
	
prod([],_,[]).

prod([H|T],L2,[X|Y]):- element_at(X,L2,H),prod(T,L2,Y).

perm(List,[H|Perm]):-delete(H,List,Rest),perm(Rest,Perm).
perm([],[]).
   
delete(X,[X|T],T).
delete(X,[H|T],[H|NT]):-delete(X,T,NT).

nosame([H|T],[X|Y]):- (H==X)->nosame(T,Y);!.

bigger([H|T],[X|Y]):- (H==X)->bigger(T,Y);((H>X),!).

myrev(Xs,Rs) :- myrev_dl(Xs,Rs-[]).
myrev_dl([],T-T).
myrev_dl([X|Xs],Rs-T) :- myrev_dl(Xs,Rs-[X|T]).

inverse(X,Y) :- list_length(X,X1),list_length(Y,X1),ider(X1,Id),prod(X,Y,Id),!.

ide(1,[1]).
ide(X,[H|T]):- Y is X-1 ,ide(Y,T),list_length([H|T],H),!.
ider(X,Z):-ide(X,T),myrev(T,Z).

comm(N,Z) :- ider(N,Id),perm(Id,X),perm(Id,Y),inverse(X,Xi),inverse(Y,Yi),prod(Xi,Yi,P1),prod(X,Y,P2),prod(P1,P2,Z).