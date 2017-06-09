% THIS DOES NOT WORK ON GNU! _FOR SOME WEIRD REASON_ COMPILE IT ON SWI.
element_at(X,[X|_],1).
element_at(X,[_|L],K) :- element_at(X,L,K1), K is K1 + 1.

list_length([]     , 0 ).
list_length([_|Xs] , L ) :- list_length(Xs,N) , L is N+1 .
  
%increment  : X1 <- X+1
incr(X,X1) :- X1 is X+1.
decr(X,X1) :- X1 is X-1.
  
  
%utilizing diff list for appending
%apend(X-Y,Y-Z,X-Z).
apend([], List, List).
apend([X|List1], List2, [X|List3]):-
 apend(List1, List2, List3).  
  
copy(H,H).

% A generic switch 
switch(X, [Val:Goal|Cases]) :-
    ( X=Val ->
        call(Goal)
    ;
        switch(X, Cases)
    ).


%reverse using diff list
myrev(Xs,Rs) :- myrev_dl(Xs,Rs-[]).

myrev_dl([],T-T).
myrev_dl([X|Xs],Rs-T) :- myrev_dl(Xs,Rs-[X|T]).

%add at end using diff list : In,Item,Out
%add_at_end(L1-[Item|Z2],Item,L1-Z2).
%add_at_end(L1-[Item|Z2],Item,L1-Z2).
% adds E to the end of list
add_at_end(E, [], [E]).
add_at_end(E, [H|T], [H|Tnew]) :- add_at_end(E, T, Tnew).

    % stack performs the push, pop and peek operations
    % to push an element onto the stack
        % ?- stack(a, [b,c,d], S).
    %    S = [a,b,c,d]
    % To pop an element from the stack
    % ?- stack(Top, Rest, [a,b,c]).
    %    Top = a, Rest = [b,c]
    % To peek at the top element on the stack
    % ?- stack(Top, _, [a,b,c]).
    %    Top = a 

stack(E, S, [E|S]).


isop(X):- (X=='*') .
isop(X):- (X=='+') .
isop(X):- (X=='-') .
isop(X):- (X=='/') .
isop(X):- (X=='^') .

%preced(X,Z) :- switch(X,[a:(Z is 4),'*':copy(Z,3),/:Z is 3, + : Z is 2, - : Z is 2]).
%operator precedence
preced(X,Z) :- switch(X,['*':(Z is 3),'^':(Z is 4),'/':(Z is 3),'+':(Z is 2),'-':(Z is 2)]).

%operator associativity
isrightassoc(Z) :- Z=='^'.
isleftassoc(Z) :- Z=='*'.
isleftassoc(Z) :- Z=='+'.
isleftassoc(Z) :- Z=='-'.
isleftassoc(Z) :- Z=='/'.

prefixz(Infix,Prefix):- myrev(Infix,Reved),parser(1,Reved,[],[],Z),myrev(Z,Prefix).
%prefix(Infix,Prefix) :- element_at(X,Infix,4),write(X).

 

%parser(Step,Reved,Stack,NOut,Out) :- list_length(Reved,Len),Len<Step,Stack==[]->copy(NOut,Out);(myrev(Stack,Rs),apend(NOut,Rs,Ans),copy(Ans,Out)).



parser(Step,Reved,CStack,COut,Out) :- (list_length(Reved,Len),Len<Step)->(CStack==[]->(copy(NOut,Out),!);(myrev(CStack,Rs),apend(COut,Rs,Ans),copy(Ans,Out),!))
;(element_at(H,Reved,Step),incr(Step,Stepp)),(integer(H)->(add_at_end(H,COut,NOut),
parser(Stepp,Reved,CStack,NOut,Out));isop(H)->
(stack(Top,_,CStack),(isop(Top),preced(Top,PT),preced(H,PH),
(isleftassoc(H), (PH =< PT) );(isrightassoc(H),PH<PT)) -> (stack(Popped,CStack,NStack),add_at_end(Popped,COut,NOut),
parser(Step,Reved,NStack,NOut,Out)); (stack(H,CStack,NStack),parser(Stepp,Reved,NStack,COut,Out))
);
(H==')'->(stack(H,CStack,NStack),parser(Stepp,Reved,NStack,COut,Out));(
(stack(Top,_,CStack),(Top==')'))->(stack(X,NStack,CStack),parser(Stepp,Reved,NStack,COut,Out));(stack(Z,NStack,CStack),
add_at_end(Z,COut,NOut),parser(Step,Reved,NStack,NOut,Out))))).  





